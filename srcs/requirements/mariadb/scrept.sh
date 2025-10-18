#!/bin/bash

# Wait for environment variables
echo "Starting MariaDB bootstrap setup..."

# Run bootstrap SQL commands directly
mysqld --bootstrap <<EOF
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';
FLUSH PRIVILEGES;
EOF

echo "✅ Database '${MYSQL_DATABASE}' and user '${MYSQL_USER}' initialized via bootstrap."
exec  mysqld_safe
