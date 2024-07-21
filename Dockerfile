# Use an official PHP runtime as a parent image
FROM php:8.2.12-apache

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install MongoDB extension and dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev \
    git \
    zip \
    unzip \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb

# Install any needed PHP extensions
RUN docker-php-ext-install mysqli

# Set the working directory
WORKDIR /var/www/html

# Copy the current directory contents into the container
COPY . .

# Copy composer.json
COPY composer.json ./

# Install Composer dependencies
RUN composer install

# Expose port 80
EXPOSE 80
