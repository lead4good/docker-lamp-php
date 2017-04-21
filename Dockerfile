FROM php:7-apache

# install the PHP extensions we need
# not found common auth mysql
# already installed curl openssl mbstring xml pear sqlite pdo
RUN set -xe \
	&& buildDeps=" \
    libjpeg-dev \
    libpng12-dev \
    libpspell-dev \
    libxml2-dev libicu-dev \
    libmcrypt-dev \
    libc-client-dev \
    libkrb5-dev \
    libpspell-dev \
    libxml2-dev \
    libicu-dev \
    libmcrypt-dev \
    libc-client-dev \
    libkrb5-dev \
    libxslt-dev \
	" \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
  && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
  && docker-php-ext-install mysqli pdo_mysql sockets opcache gd imap mcrypt intl pspell xmlrpc xsl soap zip
#  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=2'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# already enabled mime
# RUN a2dismod mpm_prefork
# RUN a2enmod mpm_worker
RUN a2enmod rewrite expires mime deflate headers

VOLUME /var/www/html

CMD ["apache2-foreground"]
