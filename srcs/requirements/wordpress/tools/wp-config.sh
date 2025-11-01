#!/bin/bash
cd /var/www/wordpress

sed -i 's/^listen\s*=.*/listen = 0.0.0.0:9000/' /etc/php/7.4/fpm/pool.d/www.conf
mkdir -p /run/php

sleep 15

wp core download --allow-root --force

wp config create \
    --dbname="${MYSQL_DATABASE}" \
    --dbuser="${MYSQL_USER}" \
    --dbpass="${MYSQL_PASSWORD}" \
    --dbhost=mariadb:3306 \
    --allow-root \
    --force

if echo "$WP_ADMIN_USER" | grep -iE 'admin|administrator'; then
    echo "❌ ERROR: Admin User '$WP_ADMIN_USER' contains a forbidden string ('admin' or 'administrator')."
else {
    echo "✅ SUCCESS: Admin User '$WP_ADMIN_USER' is clean."
    wp core install \
    --url="${WP_URL}" \
    --title="${WP_TITLE}" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASS}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --allow-root \
    --skip-email

    if echo "$NEW_USER" | grep -iE 'admin|administrator'; then
        echo "❌ ERROR: Additional User '$NEW_USER' contains a forbidden string ('admin' or 'administrator')."
    else {
        echo "✅ SUCCESS: Additional User '$WP_ADMIN_USER' is clean."
        wp user create "${NEW_USER}" "${NEW_USER_EMAIL}" \
        --role="${NEW_USER_ROLE}" \
        --user_pass="${NEW_USER_PASS}" \
        --allow-root 
    } fi

} fi



chown -R www-data:www-data /var/www/wordpress
chmod -R 755 /var/www/wordpress

exec php-fpm7.4 -F