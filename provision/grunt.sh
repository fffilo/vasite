#!/usr/bin/env bash

echo "################################"
echo "### grunt.sh ###################"
echo "################################"

### Check if nodejs is installed
npm --version > /dev/null 2>&1
NPM_IS_INSTALLED=$?
if [[ $NPM_IS_INSTALLED -ne 0 ]]; then
	sudo apt-get install -y nodejs nodejs-legacy npm
fi

### Install phantomjs
sudo npm install -g grunt
