FROM richarvey/nginx-php-fpm:latest

ENV php_vars /usr/local/etc/php/conf.d/docker-vars.ini
ENV PROJECT_PATH=/var/www

# Adjust php-fpm config
RUN echo "max_execution_time = 180" >> ${php_vars} && \
    echo "max_input_time = 180" >> ${php_vars} && \
    echo "memory_limit = 256M" >> ${php_vars}

# Install dependencies for php
RUN apk add --no-cache \
        			libmcrypt-dev \
        			libltdl imap-dev zlib-dev libzip-dev
RUN docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-configure imap --with-imap --with-imap-ssl \
    && docker-php-ext-install imap

# Set nginx config
COPY nginx.default.conf /etc/nginx/sites-available/default.conf

WORKDIR /tmp
RUN git glone https://github.com/snapycloud/crm.git $PROJECT_PATH/snapycloud
    

WORKDIR /var/www/snapycloud


RUN cd $PROJECT_PATH \
    && find . -type d -exec chmod 755 {} + && find . -type f -exec chmod 644 {} +; \
    find data custom -type d -exec chmod 775 {} + && find data custom -type f -exec chmod 664 {} +; \
    chown -R nginx:nginx .
RUN composer install
RUN npm install
RUN npm install gulp-cli@dev
RUN grunt
RUN grunt uglify
RUN mv build/tmp/client/app.min.js
RUN echo '* * * * * cd /var/www/snapycloud; /usr/local/bin/php -f cron.php > /dev/null 2>&1' >> /etc/crontabs/root
EXPOSE 80
CMD ["sh","-c","crond && /start.sh"]
