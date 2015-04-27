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
mv /tmp/wordpress /www/public
rm -f /tmp/wp.zip
rm -rf /tmp/wordpress/

### Wordpress config
cp /www/public/wp-config-sample.php /www/public/wp-config.php
sudo sed -i "s/database_name_here/${ENVIRONMENT}/" /www/public/wp-config.php
sudo sed -i "s/username_here/root/" /www/public/wp-config.php
sudo sed -i "s/password_here/root/" /www/public/wp-config.php
sudo sed -i "s/localhost/`ifconfig eth1 | grep 'inet addr:' | awk '{print $2}' | cut -f2 -d:`/" /www/public/wp-config.php
sudo sed -i "0,/put your unique phrase here/s/put your unique phrase here/`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`/" /www/public/wp-config.php
sudo sed -i "0,/put your unique phrase here/s/put your unique phrase here/`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`/" /www/public/wp-config.php
sudo sed -i "0,/put your unique phrase here/s/put your unique phrase here/`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`/" /www/public/wp-config.php
sudo sed -i "0,/put your unique phrase here/s/put your unique phrase here/`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`/" /www/public/wp-config.php
sudo sed -i "0,/put your unique phrase here/s/put your unique phrase here/`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`/" /www/public/wp-config.php
sudo sed -i "0,/put your unique phrase here/s/put your unique phrase here/`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`/" /www/public/wp-config.php
sudo sed -i "0,/put your unique phrase here/s/put your unique phrase here/`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`/" /www/public/wp-config.php
sudo sed -i "0,/put your unique phrase here/s/put your unique phrase here/`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`/" /www/public/wp-config.php

### Redirect to index.php
apache2 -v > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
	echo "# BEGIN WordPress" > /www/public/.htaccess
	echo -e "<IfModule mod_rewrite.c>" >> /www/public/.htaccess
	echo -e "\tRewriteEngine On" >> /www/public/.htaccess
	echo -e "\tRewriteBase /" >> /www/public/.htaccess
	echo -e "\tRewriteRule ^index\.php$ - [L]" >> /www/public/.htaccess
	echo -e '\tRewriteCond %{REQUEST_FILENAME} !-f' >> /www/public/.htaccess
	echo -e '\tRewriteCond %{REQUEST_FILENAME} !-d' >> /www/public/.htaccess
	echo -e "\tRewriteRule . /index.php [L]" >> /www/public/.htaccess
	echo "</IfModule>" >> /www/public/.htaccess
	echo "# END WordPress" >> /www/public/.htaccess
fi
nginx -v > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
	sudo sed -ri "s/try_files(.*)/try_files \$uri \$uri\/ \/index.php?\$args;/" /etc/nginx/sites-available/${ENVIRONMENT}
fi
