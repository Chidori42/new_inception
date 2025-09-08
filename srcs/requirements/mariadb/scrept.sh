#!/bin/bash

echo "Setting up MariaDB..."

# Create necessary directories and set permissions
mkdir -p /run/mysqld /var/lib/mysql
chown -R mysql:mysql /run/mysqld /var/lib/mysql
chmod 755 /run/mysqld

# Initialize MariaDB data directory if it doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --rpm --auth-root-authentication-method=normal
fi

# Start MariaDB temporarily in background for setup
echo "Starting MariaDB temporarily..."
mysqld_safe --user=mysql --datadir=/var/lib/mysql --skip-grant-tables --socket=/run/mysqld/mysqld.sock &
MARIADB_PID=$!

# Wait for MariaDB to start
echo "Waiting for MariaDB to be ready..."
timeout=30
while ! mysqladmin ping --socket=/run/mysqld/mysqld.sock --silent 2>/dev/null; do
    timeout=$((timeout - 1))
    if [ $timeout -le 0 ]; then
        echo "ERROR: MariaDB failed to start within 30 seconds"
        exit 1
    fi
    echo "Waiting... ($timeout seconds left)"
    sleep 1
done

echo "MariaDB is ready! Setting up database and user..."

# Set root password and create database/user
mysql --socket=/run/mysqld/mysqld.sock -e "FLUSH PRIVILEGES;"
mysql --socket=/run/mysqld/mysqld.sock -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql --socket=/run/mysqld/mysqld.sock -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mysql --socket=/run/mysqld/mysqld.sock -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql --socket=/run/mysqld/mysqld.sock -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
mysql --socket=/run/mysqld/mysqld.sock -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

echo "Database '${MYSQL_DATABASE}' and user '${MYSQL_USER}' created successfully!"

# Stop the temporary MariaDB instance
echo "Stopping temporary MariaDB instance..."
mysqladmin --socket=/run/mysqld/mysqld.sock -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
wait $MARIADB_PID

echo "Starting MariaDB in production mode..."
# Start MariaDB in foreground to keep container running
exec mysqld_safe --user=mysql --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock