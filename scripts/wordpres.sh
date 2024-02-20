#!/bin/bash


if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo "No hay .env."
  exit 1
fi


sudo apt update
sudo apt upgrade -y

sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y

sudo mariadb -u root -p"${MARIADB_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS ${MARIADB_DATABASE};"
sudo mariadb -u root -p"${MARIADB_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS'${MARIADB_USER}'@'localhost' IDENTIFIED BY '${MARIADB_PASSWORD}';"
sudo mariadb -u root -p"${MARIADB_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON ${MARIADB_DATABASE}.* TO '${MARIADB_USER}'@'localhost' WITH GRANT OPTION;"
sudo mariadb -u root -p"${MARIADB_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"


sudo sed -i '5i <Directory /var/www/html/>\n AllowOverride All\n </Directory>' /etc/apache2/sites-available/000-default.conf
sudo a2enmod rewrite
sudo systemctl restart apache2


sudo apt install wget unzip -y
sudo wget https://es.wordpress.org/latest-es_ES.zip -P /tmp
sudo unzip /tmp/latest-es_ES.zip -d /tmp
sudo mv -f /tmp/wordpress/* /var/www/html
sudo chown -R www-data:www-data /var/www/html
sudo systemctl restart apache2


