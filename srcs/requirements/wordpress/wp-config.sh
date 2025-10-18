#!/bin/bash
set -e

cd /var/www/wordpress

# Configure PHP-FPM
sed -i 's/^listen\s*=.*/listen = 0.0.0.0:9000/' /etc/php/7.4/fpm/pool.d/www.conf
mkdir -p /run/php

# Wait for MariaDB bootstrap
sleep 15


# Download WordPress
wp core download --allow-root --force

# Create wp-config.php
wp config create \
    --dbname="${MYSQL_DATABASE}" \
    --dbuser="${MYSQL_USER}" \
    --dbpass="${MYSQL_PASSWORD}" \
    --dbhost=mariadb:3306 \
    --allow-root \
    --force

# Install WordPress
wp core install \
    --url="${WP_URL}" \
    --title="${WP_TITLE}" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASS}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --allow-root \
    --skip-email

# Create additional user
wp user create "${NEW_USER}" "${NEW_USER_EMAIL}" \
    --role="${NEW_USER_ROLE}" \
    --user_pass="${NEW_USER_PASS}" \
    --allow-root 

# Set permissions
chown -R www-data:www-data /var/www/wordpress
chmod -R 755 /var/www/wordpress

# Start PHP-FPM
exec php-fpm7.4 -F