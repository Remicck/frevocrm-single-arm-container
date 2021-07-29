FROM php:7.4-apache
ADD ./php.ini /usr/local/etc/php/conf.d/custom.php.ini
RUN set -xe; \
    apt-get update -yqq && \
    apt-get install -yqq --no-install-recommends \
      apt-utils vim gettext git wget \
      default-mysql-client \
      # for gd
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libpng-dev \
      libwebp-dev \
      libxpm-dev \
      # for imap
      libc-client-dev libkrb5-dev \
      # for ImageMagick
      libmagickwand-dev \
      # for oniguruma
      libonig-dev \
      # for zip
      libzip-dev zip unzip && \
      # Install the zip extension
      docker-php-ext-install zip \
    && docker-php-ext-install bcmath gettext mbstring mysqli pdo pdo_mysql zip \
    && docker-php-ext-configure mbstring --disable-mbregex \
    # gd exif
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd exif \
    # for imap
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install -j$(nproc) imap
RUN apt install -y mariadb-server
ADD ./my.cnf /etc/mysql/my.cnf
ADD ./mariadb_update.sh /root/mariadb_update.sh
RUN sh /root/mariadb_update.sh
RUN cd /var/www/html/ \
    && git clone https://github.com/thinkingreed-inc/F-RevoCRM.git crm \
    && chmod -R 755 /var/www/html/crm \
    && chown -R www-data.www-data /var/www/html/crm
ADD ./start.sh /root/start.sh
CMD ["sh", "/root/start.sh"]
