FROM debian:buster-slim

ENV PROJECT_ROOT=/var/www/html
ENV DATABASE_URL=mysql://root:root@mysql:3306/app

RUN apt-get update && apt-get install -y \
        composer \
        php-cli \
        php-common \
        php-curl \
        php-fpm \
        php-gd \
        php-intl \
        php-mbstring \
        php-mysql \
        php-apcu \
        php-json \
        php-xml \
        php-xmlrpc \
        php-zip \
        supervisor \
        curl \
        bash \
        nginx \
        wget \
        unzip \
    && rm /etc/nginx/sites-available/default

RUN mkdir -p /run/php/

# Copy system configs
COPY etc /etc

RUN usermod -u 1000 www-data

WORKDIR $PROJECT_ROOT

# Expose the port nginx is reachable on
EXPOSE 8000


RUN wget -O in.zip https://www.shopware.com/en/Download/redirect/version/sw6/file/install_v6.3.1.1_5a5aa9e251c05ce73974ededb6075b2a18baac8d.zip \
    && unzip -o in.zip  \
    && rm in.zip \
    && touch install.lock

ADD --chown=www-data . . 
RUN chown -R www-data $PROJECT_ROOT 

USER www-data

ENTRYPOINT ["./bin/entrypoint.sh"]