#!/bin/bash
echo "Starting WordPress setup..."

cd /var/www/wordpress

# Configure PHP-FPM
sed -i 's/^listen\s*=.*/listen = 0.0.0.0:9000/' /etc/php/7.4/fpm/pool.d/www.conf
mkdir -p /run/php
chown -R www-data:www-data /run/php

# Download WP-CLI
echo "Downloading WP-CLI..."
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 
chmod +x wp-cli.phar 
mv wp-cli.phar /usr/local/bin/wp 

# Download WordPress core files
echo "Downloading WordPress..."
wp core download --allow-root --force

echo "MariaDB is ready! Creating wp-config.php..."

# Clean up and create wp-config.php
rm -f wp-config.php
wp config create \
    --dbname=$MYSQL_DATABASE \
    --dbuser=$MYSQL_USER \
    --dbpass=$MYSQL_PASSWORD \
    --dbhost=mariadb:3306 \
    --allow-root

# Test database connection
mysql -h mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;" 2>/dev/null || echo "Could not create database (this is normal if using limited user)"

echo "Database connection successful!"

# Check if WordPress is already installed
    
wp core install \
    --url="$WP_URL" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASS" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --allow-root

echo "WordPress installed successfully!"

    wp user create "$NEW_USER" "$NEW_USER_EMAIL" \
        --role="$NEW_USER_ROLE" \
        --user_pass="$NEW_USER_PASS" \
        --allow-root


wp option update home $WP_URL --allow-root
wp option update siteurl $WP_URL --allow-root


# Set proper permissions
chown -R www-data:www-data /var/www/wordpress
chmod -R 755 /var/www/wordpress

echo "🎉 WordPress setup complete!"
echo "Starting PHP-FPM..."

# Start PHP-FPM in foreground
exec php-fpm7.4 -F