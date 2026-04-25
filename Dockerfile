FROM php:8.3-cli

# System dependencies
RUN apt-get update && apt-get install -y \
    git curl unzip libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev zip

# PHP extensions (CRITICAL FIX)
RUN docker-php-ext-install pdo pdo_mysql

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd exif

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY . .

RUN composer install --no-dev --optimize-autoloader

EXPOSE 10000

CMD php artisan serve --host=0.0.0.0 --port=10000