#!/usr/bin/env bash

echo "################################"
echo "### apache.sh ##################"
echo "################################"

# Test apache installation
apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?
if [[ $APACHE_IS_INSTALLED -eq 0 ]]; then
	echo "Apache already installed... Skipping apache installation."
	exit 0
fi

# Test nginx installation
nginx -v > /dev/null 2>&1
NGINX_IS_INSTALLED=$?
if [[ $NGINX_IS_INSTALLED -eq 0 ]]; then
	echo "Nginx already installed... Skipping apache installation."
	exit 0
fi

### Install apache web server
sudo apt-get install -y apache2

### Add vagrant user to www-data group
sudo usermod -a -G www-data vagrant
sudo usermod -a -G vagrant www-data

### Fix domainname warning
echo "# created by vagrant apache.sh script" | sudo tee /etc/apache2/conf-available/fqdn.conf >/dev/null
echo "ServerName localhost" | sudo tee -a /etc/apache2/conf-available/fqdn.conf >/dev/null
sudo a2enconf fqdn

### Backup default config
sudo cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.default

### Allow override
#sudo sh -c "awk '/<Directory \/var\/www\/>/,/AllowOverride None/{sub(\"None\", \"All\",\$0)}{print}' /etc/apache2/apache2.conf.default > /etc/apache2/apache2.conf"

### Set environment
sudo mkdir -p /www/app
sudo mkdir -p /www/bootstrap
sudo mkdir -p /www/vendor
sudo mkdir -p /www/workbench
sudo mkdir -p /www/public
sudo mkdir -p /www/public/css
sudo mkdir -p /www/public/img
sudo mkdir -p /www/public/js
sudo cp /var/www/html/index.html /www/public/index.html

### Add jquery to js
sudo wget --quiet http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js -O /www/public/js/jquery.min.js

### Set virtual host
echo "<VirtualHost *:80>" | sudo tee /etc/apache2/sites-available/${ENVIRONMENT}.conf >/dev/null
echo "    DocumentRoot /www/public" | sudo tee -a /etc/apache2/sites-available/${ENVIRONMENT}.conf >/dev/null
echo "    ServerAdmin webmaster@${ENVIRONMENT}" | sudo tee -a /etc/apache2/sites-available/${ENVIRONMENT}.conf >/dev/null
echo "    <Directory /www/public>" | sudo tee -a /etc/apache2/sites-available/${ENVIRONMENT}.conf >/dev/null
echo "        Options Indexes FollowSymLinks MultiViews" | sudo tee -a /etc/apache2/sites-available/${ENVIRONMENT}.conf >/dev/null
echo "        AllowOverride All" | sudo tee -a /etc/apache2/sites-available/${ENVIRONMENT}.conf >/dev/null
echo "        Allow From All" | sudo tee -a /etc/apache2/sites-available/${ENVIRONMENT}.conf >/dev/null
echo "        Require all granted" | sudo tee -a /etc/apache2/sites-available/${ENVIRONMENT}.conf >/dev/null
echo "    </Directory>" | sudo tee -a /etc/apache2/sites-available/${ENVIRONMENT}.conf >/dev/null
echo "</VirtualHost>" | sudo tee -a /etc/apache2/sites-available/${ENVIRONMENT}.conf >/dev/null

### Enable module(s)
sudo a2enmod rewrite

### Enable virtual host
sudo a2dissite 000-default.conf
sudo a2ensite ${ENVIRONMENT}

### Restart server
sudo service apache2 restart
