#!/usr/bin/env bash

echo "################################"
echo "### wordpress.sh ###############"
echo "################################"

### Empty docroot
sudo rm -rf /www/*
find /www -type f -print0 | xargs -0 rm

### Install latest wordpress
wget -O /tmp/wp.zip https://wordpress.org/latest.zip
unzip /tmp/wp.zip -d /tmp
mv /tmp/wordpress/* /www
rm -f /tmp/wp.zip
rm -rf /tmp/wordpress/

### Wordpress config
cp /www/wp-config-sample.php /www/wp-config.php
sudo sed -i "s/database_name_here/${ENVIRONMENT}/" /www/wp-config.php
sudo sed -i "s/username_here/root/" /www/wp-config.php
sudo sed -i "s/password_here/root/" /www/wp-config.php
sudo sed -i "0,/put your unique phrase here/s/put your unique phrase here/`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`/" /www/wp-config.php
sudo sed -i "0,/put your unique phrase here/s/put your unique phrase here/`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`/" /www/wp-config.php
sudo sed -i "0,/put your unique phrase here/s/put your unique phrase here/`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`/" /www/wp-config.php
sudo sed -i "0,/put your unique phrase here/s/put your unique phrase here/`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`/" /www/wp-config.php
sudo sed -i "0,/put your unique phrase here/s/put your unique phrase here/`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`/" /www/wp-config.php
sudo sed -i "0,/put your unique phrase here/s/put your unique phrase here/`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`/" /www/wp-config.php
sudo sed -i "0,/put your unique phrase here/s/put your unique phrase here/`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`/" /www/wp-config.php
sudo sed -i "0,/put your unique phrase here/s/put your unique phrase here/`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`/" /www/wp-config.php

### Virtual environment
sudo sed -i "s|/www/public|/www|" /etc/apache2/sites-available/${ENVIRONMENT}.conf
sudo service apache2 reload
