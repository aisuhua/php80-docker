FROM ubuntu:22.04

LABEL maintainer="aisuhua <1079087531@qq.com>"

ARG DEBIAN_FRONTEND=noninteractive

ADD sources.list /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    software-properties-common \
    build-essential \
    tzdata \
    locales \
    vim \
    net-tools \
    curl \
    wget

RUN add-apt-repository -y ppa:ondrej/php \
&& sed -i "s/http:\/\/ppa.launchpad.net/https:\/\/launchpad.proxy.ustclug.org/g" /etc/apt/sources.list.d/*.list

RUN apt-get update && apt-get install -y \
    php8.0 \
    php8.0-cli \
    php8.0-fpm \
    php8.0-curl \
    php8.0-dom \
    php8.0-fileinfo \
    php8.0-fpm \
    php8.0-gd \
    php8.0-gettext \
    php8.0-mbstring \
    php8.0-pdo \
    php8.0-phar \
    php8.0-psr \
    php8.0-opcache \
    php8.0-simplexml \
    php8.0-tokenizer \
    php8.0-xml \
    php8.0-bcmath \
    php8.0-zip \
    php8.0-mysqli \
    php8.0-sqlite \
    php8.0-soap \
    php8.0-ldap \
    php8.0-iconv \
    php-pear \
    php8.0-intl \
    php8.0-ldap \
    php8.0-bz2 \
    php8.0-ctype \
    php8.0-exif \
    php8.0-apcu \
    php8.0-imagick \
    php8.0-msgpack \
    php8.0-igbinary \
    php8.0-mongodb \
    php8.0-memcache \
    php8.0-memcached \
    php8.0-redis \
    php8.0-amqp \
    php8.0-xdebug \
    php8.0-phalcon5 \
    php8.0-snmp \
    php8.0-gmp \
&& apt-get remove --purge --auto-remove -y \
&& rm -rf /var/lib/apt/lists/*

RUN wget https://mirrors.cloud.tencent.com/composer/composer.phar \
&& mv composer.phar /usr/local/bin/composer \
&& chmod 755 /usr/local/bin/composer \
&& composer config -g repo.packagist composer https://mirrors.cloud.tencent.com/composer/

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo Asia/Shanghai | tee /etc/timezone \
&& cp /etc/php/8.0/fpm/pool.d/www.conf /etc/php/8.0/fpm/pool.d/www.conf.default \
&& cp /etc/php/8.0/fpm/php.ini /etc/php/8.0/fpm/php.ini.default \
&& cp /etc/php/8.0/cli/php.ini /etc/php/8.0/cli/php.ini.default \
&& sed -i "s/;date.timezone =.*/date.timezone = PRC/" /etc/php/8.0/fpm/php.ini \
&& sed -i "s/upload_max_filesize =.*/upload_max_filesize = 10240M/" /etc/php/8.0/fpm/php.ini \
&& sed -i "s/post_max_size =.*/post_max_size = 10240M/" /etc/php/8.0/fpm/php.ini \
&& sed -i "s/;memory_limit =.*/memory_limit = 10240M/" /etc/php/8.0/fpm/php.ini \
&& sed -i "s/;date.timezone =.*/date.timezone = PRC/" /etc/php/8.0/cli/php.ini \
&& sed -i "s/upload_max_filesize =.*/upload_max_filesize = 10240M/" /etc/php/8.0/cli/php.ini \
&& sed -i "s/post_max_size =.*/post_max_size = 10240M/" /etc/php/8.0/cli/php.ini \
&& mkdir /run/php \
&& chmod 775 /run/php \
&& mkdir /opt/www \
&& chmod 775 /opt

COPY docker.conf /etc/php/8.0/fpm/pool.d/docker.conf
COPY zz-docker.conf /etc/php/8.0/fpm/pool.d/zz-docker.conf

COPY docker-entrypoint.sh /
ENTRYPOINT ["sh", "/docker-entrypoint.sh"]

USER 1001
WORKDIR /opt/www

STOPSIGNAL SIGQUIT

EXPOSE 9000 9001
CMD ["php-fpm8.0"]
#ENTRYPOINT ["tail"]
#CMD ["-f","/dev/null"]
