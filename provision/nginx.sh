#!/usr/bin/env bash

echo "################################"
echo "### nginx.sh ##################"
echo "################################"

# Test apache installation
apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?
if [[ $APACHE_IS_INSTALLED -eq 0 ]]; then
	echo "Apache already installed... Skipping nginx installation."
	exit 0
fi

# Test nginx installation
nginx -v > /dev/null 2>&1
NGINX_IS_INSTALLED=$?
if [[ $NGINX_IS_INSTALLED -eq 0 ]]; then
	echo "Nginx already installed... Skipping nginx installation."
	exit 0
fi

### Install nginx web server
sudo apt-get install -y nginx

### Add vagrant user to www-data group
sudo usermod -a -G www-data vagrant

### Backup default config
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.default

### Set environment
sudo mkdir -p /www/app
sudo mkdir -p /www/bootstrap
sudo mkdir -p /www/vendor
sudo mkdir -p /www/workbench
sudo mkdir -p /www/public
sudo mkdir -p /www/public/css
sudo mkdir -p /www/public/img
sudo mkdir -p /www/public/js
sudo cp /usr/share/nginx/html/index.html /www/public/index.html

### Add jquery to js
sudo wget --quiet http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js -O /www/public/js/jquery.min.js

### Set virtual host
echo "server {" | sudo tee /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
echo "    listen 80;" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
echo "    #server_name localhost;" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
echo "    root /www/public;" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
echo "    index index.html index.htm;" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
echo "    #error_page 404 /404.html;" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
echo "    #error_page 500 502 503 504 /50x.html;" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
echo "    #location = /50x.html {" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
echo "    #    root /usr/share/nginx/www;" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
echo "    #}" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
echo "    location / {" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
echo "        try_files \$uri \$uri/ =404;" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
echo "    }" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
echo "    location ~ /\.ht {" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
echo "        deny all;" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
echo "    }" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
echo "}" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null

### Enable virtual host
sudo unlink /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/${ENVIRONMENT} /etc/nginx/sites-enabled/${ENVIRONMENT}

### Restart server
sudo service nginx restart
