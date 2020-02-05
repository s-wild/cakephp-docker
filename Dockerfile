FROM ubuntu:18.04
MAINTAINER Simon Wild <simonwild@protonmail.com>

# Install packages and PHP 7.4
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:ondrej/php

RUN apt-get update -y
RUN apt-get upgrade -y

RUN apt-get install -y python python-pip \
  git composer nginx php7.4-fpm php7.4-intl php7.4-mbstring \
  php7.4-zip php7.4-gmp php7.4-gd php7.4-zip php7.4-intl php7.4-simplexml php7.4-xml \
  php7.4-pdo php7.4-curl php7.4-gmagick php7.4-bcmath pkg-config \
  php7.4-mysql php-dev libmcrypt-dev gcc make autoconf libc-dev

# Add Nginx Conf
RUN mkdir -p /var/www/html/

COPY site.conf /etc/nginx/sites-available/default
COPY localhost.crt /etc/nginx/localhost.crt
COPY localhost.key /etc/nginx/localhost.key

WORKDIR /var/www/html/


ENTRYPOINT service php7.4-fpm start && service nginx start && /bin/bash

