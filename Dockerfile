FROM php:8.1-apache
RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    libzip-dev \
    unzip libicu-dev \
    libcurl4-openssl-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev

RUN a2enmod rewrite

RUN  docker-php-ext-configure intl && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install mysqli zip intl curl gettext pdo_mysql


RUN a2enmod rewrite headers
# INSTALL AND UPDATE COMPOSER
COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN composer self-update


# download easyapointments
RUN curl https://github.com/alextselegidis/easyappointments/releases/download/1.4.3/easyappointments-1.4.3.zip -L -O \
    && unzip easyappointments-1.4.3.zip -d /var/www/html/ && chown -R www-data:www-data /var/www/html/