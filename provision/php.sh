#!/usr/bin/env bash

echo "################################"
echo "### php.sh #####################"
echo "################################"

# Test webserver installation
apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?
nginx -v > /dev/null 2>&1
NGINX_IS_INSTALLED=$?

### Install PHP
sudo add-apt-repository -y ppa:ondrej/php5-5.6
sudo apt-get update
sudo apt-get install -y php-pear php5-cli php5-curl php5-mcrypt php5-gd php5-xdebug php5-gmp php5-mysql php5-pgsql php5-sqlite

### Backup default config
sudo cp /etc/php5/cli/php.ini /etc/php5/cli/php.ini.default >/dev/null

### Enable error reporting
sudo sed -i "s/disable_functions = .*/disable_functions = /" /etc/php5/cli/php.ini

### Enable mcrypt module
sudo php5enmod mcrypt

### Set timezone
cat /etc/php5/cli/php.ini | sed -r "s|;?date.timezone =.*|date.timezone = ${TIMEZONE}|" | sudo tee /etc/php5/cli/php.ini >/dev/null

### Set xdebug
echo "xdebug.scream=0" | sudo tee -a /etc/php5/mods-available/xdebug.ini >/dev/null
echo "xdebug.cli_color=1" | sudo tee -a /etc/php5/mods-available/xdebug.ini >/dev/null
echo "xdebug.show_local_vars=1" | sudo tee -a /etc/php5/mods-available/xdebug.ini >/dev/null
echo "xdebug.max_nesting_level=300" | sudo tee -a /etc/php5/mods-available/xdebug.ini >/dev/null

if [[ $APACHE_IS_INSTALLED -eq 0 ]]; then
	### Install php module for apache
	sudo apt-get install -y php5 libapache2-mod-php5

	### Backup default config
	sudo cp /etc/php5/apache2/php.ini /etc/php5/apache2/php.ini.default >/dev/null

	### Set timezone
	cat /etc/php5/apache2/php.ini | sed -r "s|;?date.timezone =.*|date.timezone = ${TIMEZONE}|" | sudo tee /etc/php5/apache2/php.ini >/dev/null

	### Set execution and file upload size
	cat /etc/php5/apache2/php.ini | sed -r "s|;?upload_max_filesize =.*|upload_max_filesize = 64M|" | sudo tee /etc/php5/apache2/php.ini >/dev/null
	cat /etc/php5/apache2/php.ini | sed -r "s|;?post_max_size =.*|post_max_size = 64M|" | sudo tee /etc/php5/apache2/php.ini >/dev/null
	cat /etc/php5/apache2/php.ini | sed -r "s|;?max_execution_time =.*|max_execution_time = 90|" | sudo tee /etc/php5/apache2/php.ini >/dev/null

	### Enable error reporting
	sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
	sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini
fi
if [[ $NGINX_IS_INSTALLED -eq 0 ]]; then
	### Install php FastCGI Process Manager
	sudo apt-get install -y php5-fpm

	### Backup default config
	sudo cp /etc/php5/fpm/php.ini /etc/php5/fpm/php.ini.default >/dev/null
	sudo cp /etc/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf.default >/dev/null

	### Disable fastcgi fixpathinfo
	cat /etc/php5/fpm/php.ini | sed -r "s/;?cgi.fix_pathinfo=.*/cgi.fix_pathinfo=0/" | sudo tee /etc/php5/fpm/php.ini >/dev/null

	### Set timezone
	cat /etc/php5/fpm/php.ini | sed -r "s|;?date.timezone =.*|date.timezone = ${TIMEZONE}|" | sudo tee /etc/php5/fpm/php.ini >/dev/null

	### Set execution and file upload size
	cat /etc/php5/fpm/php.ini | sed -r "s|;?upload_max_filesize =.*|upload_max_filesize = 64M|" | sudo tee /etc/php5/fpm/php.ini >/dev/null
	cat /etc/php5/fpm/php.ini | sed -r "s|;?post_max_size =.*|post_max_size = 64M|" | sudo tee /etc/php5/fpm/php.ini >/dev/null
	cat /etc/php5/fpm/php.ini | sed -r "s|;?max_execution_time =.*|max_execution_time = 90|" | sudo tee /etc/php5/fpm/php.ini >/dev/null

	### Enable error reporting
	sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/fpm/php.ini
	sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/fpm/php.ini

	### Enable php file extension
	cat /etc/nginx/sites-enabled/${ENVIRONMENT} | sed -r "s/\s*index.*/    index index.php index.html index.htm;/" | sudo tee /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null

	### Configure virtual host
	sudo sed -i "s/^}$//" /etc/nginx/sites-available/${ENVIRONMENT}
	sudo sed -i "/^$/d" /etc/nginx/sites-available/${ENVIRONMENT}
	echo "    location ~ \.php\$ {" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
	echo "        try_files \$uri =404;" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
	echo "        fastcgi_pass unix:/var/run/php5-fpm.sock;" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
	echo "        fastcgi_index index.php;" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
	echo "        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
	echo "        include fastcgi_params;" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
	echo "    }" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
	echo "}" | sudo tee -a /etc/nginx/sites-available/${ENVIRONMENT} >/dev/null
fi

### Install composer
sudo sh -c "curl -sS https://getcomposer.org/installer | php"
sudo mv composer.phar /usr/local/bin/composer

### PHP info as default page
sudo echo -e "<?php\nphpinfo();\n?>\n" | sudo tee /www/public/phpinfo.php >/dev/null

### Restart server
if [[ $APACHE_IS_INSTALLED -eq 0 ]]; then
	sudo service apache2 restart
fi
if [[ $NGINX_IS_INSTALLED -eq 0 ]]; then
	sudo service php5-fpm restart
	sudo service nginx restart
fi
