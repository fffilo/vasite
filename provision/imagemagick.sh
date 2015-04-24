#!/usr/bin/env bash

echo "################################"
echo "### imagemagick.sh #############"
echo "################################"

### Install imagemagick
sudo apt-get install -y imagemagick

### Install php imagemagick
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?
if [[ $PHP_IS_INSTALLED -ne 0 ]]; then
	sudo apt-get install -y php5-imagick
fi
