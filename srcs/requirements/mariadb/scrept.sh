#!/bin/bash

service mariadb  start
#Wait mariadb to start
echo "Wait Mariad Stating... "
sleep 10

#Create DataBase User
mysqladmin -u root password "${MYSQL_ROOT_PASSWORD}"
mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' ;"
mysql -e "FLUSH PRIVILEGES;"

echo "Database '$MYSQL_DATABASE' and user '$MYSQL_USER' created."

service mariadb  stop
# Finally run MariaDB in foreground (to keep container alive)
exec mysqld_safe