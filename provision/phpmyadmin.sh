#!/usr/bin/env bash

echo "################################"
echo "### phpmyadmin.sh ##############"
echo "################################"

# Test webserver/database installation
apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?
nginx -v > /dev/null 2>&1
NGINX_IS_INSTALLED=$?
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?
mysql --version > /dev/null 2>&1
MYSQL_IS_INSTALLED=$?

if [[ $MYSQL_IS_INSTALLED -ne 0 ]]; then
	echo "MySql is not installed... Skipping phpmyadmin installation."
	exit 0
fi
if [[ $PHP_IS_INSTALLED -ne 0 ]]; then
	echo "PHP is not installed... Skipping phpmyadmin installation."
	exit 0
fi
if [[ $APACHE_IS_INSTALLED -ne 0 && $NGINX_IS_INSTALLED -ne 0 ]]; then
	echo "Web server is not installed... Skipping phpmyadmin installation."
	exit 0
fi

### Install phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password root"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password root"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password root"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get install -y phpmyadmin

### Configure virtual host
if [[ $NGINX_IS_INSTALLED -eq 0 ]]; then
	sudo sed -i "s/^}$//" /etc/nginx/sites-available/${ENVIRONMENT}
	sudo sed -i "/^$/d" /etc/nginx/sites-available/${ENVIRONMENT}
	echo "    location /phpmyadmin {" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
	echo "        root /usr/share/;" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
	echo "        index index.php index.html index.htm;" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
	echo "        location ~ ^/phpmyadmin/(.+\.php)\$ {" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
	echo "            try_files \$uri =404;" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
	echo "            root /usr/share;" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
	echo "            fastcgi_pass unix:/var/run/php5-fpm.sock;" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
	echo "            fastcgi_index index.php;" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
	echo "            fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
	echo "            include fastcgi_params;" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
	echo "        }" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
	echo "    }" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
	echo "}" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
fi

### Restart server
if [[ $APACHE_IS_INSTALLED -eq 0 ]]; then
	sudo service apache2 restart
fi
if [[ $NGINX_IS_INSTALLED -eq 0 ]]; then
	sudo service nginx restart
fi
