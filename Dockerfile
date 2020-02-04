FROM ubuntu:18.04
MAINTAINER Simon Wild <tech@720strategies.com>

# Install packages and PHP 7.4
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -q && apt-get install -y python python-pip \
  git composer nginx php7.4-fpm php7.4-intl php7.4-mbstring \
  php7.4-zip php7.4-gmp php7.4-gd php7.4-zip php7.4-intl php7.4-simplexml php7.4-xml \
  php7.4-pdo php7.4-curl php7.4-imagick php7.4-gmagick php7.4-bcmath pkg-config \
  php7.4-mysql php-dev libmcrypt-dev gcc make autoconf libc-dev

RUN echo '' | pecl install mcrypt-1.0.1
RUN echo "extension=mcrypt.so" | tee -a /etc/php/7.4/fpm/php.ini
RUN echo "extension=mcrypt.so" | tee -a /etc/php/7.4/cli/php.ini

# Add Nginx Conf
RUN mkdir -p /var/www/html/

COPY site.conf /etc/nginx/sites-available/default
#COPY 720cloud.io /var/www/html/720cloud.io/.

WORKDIR /var/www/html/


## For linux ### RUN sed -i -e "s/DB_HOST=127.0.0.1/DB_HOST=`/sbin/ip route|awk '/default/ { print $3 }'`/" .env
#RUN sed -i -e "s/DB_HOST=127.0.0.1/DB_HOST=docker.for.mac.localhost/" .env
#RUN sed -i -e "s/DB_DATABASE=encompasscms/DB_DATABASE=encompass/" .env
#RUN cp .env htdocs/config/.

# Set workdir (no more cd from now) and composer
#WORKDIR /var/www/html/720cloud.io/htdocs
#RUN composer -n install --ignore-platform-reqs

#RUN chgrp -R www-data logs tmp /var/www/html/720cloud.io/htdocs && chmod -R g+rw logs tmp

#WORKDIR /var/www/html/720cloud.io


ENTRYPOINT service php7.4-fpm start && service nginx start && /bin/bash

# RUN composer install --no-dev --no-interaction -o -d/var/www/html/bobbymckeys.com/htdocs
