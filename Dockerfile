FROM php:5-apache

RUN a2enmod rewrite

RUN docker-php-ext-install -j$(nproc) mysql
