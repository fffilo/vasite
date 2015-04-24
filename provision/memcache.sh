#!/usr/bin/env bash

echo "################################"
echo "### memcache.sh ################"
echo "################################"

### Install memcached
sudo apt-get install -y memcached

### Install php memcached
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?
if [[ $PHP_IS_INSTALLED -ne 0 ]]; then
	sudo apt-get install -y php5-memcache
fi

### Backup config
sudo cp /etc/memcached.conf /etc/memcached.conf.default
