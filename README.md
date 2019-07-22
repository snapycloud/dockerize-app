# Snapycloud in Docker

*Note:* This is an unofficial Docker image of [SNAPYCLOUD](https://www.snapycloud.com/).

Snapycloud Docker image with nginx and PHP 7.2. For now, the installation wizard has to be manually completed on initial start.

Run
------

The docker-compose file creates and attaches a MySQL database container. The database password can be set by copying `.env.dist` to `.env` and changing the password variable. Go to the repository directory for all steps.

##### 1. Build Docker image

    docker build -t "snapycloud" .

##### 2. Start containers

    docker-compose up


After the containers are up and running go to `http://localhost:10081/install` and follow the steps of the installation wizard. For the database host fill in `mysql` (as this is the linked container in the docker-compose file).

Notes
------


For another version just change the `APP_VERSION` environment variable and build a new image.

By default, data directory from Snapycloud is mapped to `./snapycloud-data` in the host system for persisting configuration and uploads. All MySQL data is mapped to `./mysql-data`.
