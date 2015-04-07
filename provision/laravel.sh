#!/usr/bin/env bash

echo "################################"
echo "### laravel.sh #################"
echo "################################"

### Empty docroot
sudo rm -rf /www/*
find /www -type f -print0 | xargs -0 rm

### Install latest laravel
sudo composer create-project --prefer-dist laravel/laravel /www/

### Set environment
echo "APP_ENV=local" | sudo tee /www/.env >/dev/null
echo "APP_DEBUG=true" | sudo tee -a /www/.env >/dev/null
echo "DB_HOST=`ifconfig eth1 | grep 'inet addr:' | awk '{print $2}' | cut -f2 -d:`" | sudo tee -a /www/.env >/dev/null
echo "DB_DATABASE=${ENVIRONMENT}" | sudo tee -a /www/.env >/dev/null
echo "DB_USERNAME=root" | sudo tee -a /www/.env >/dev/null
echo "DB_PASSWORD=root" | sudo tee -a /www/.env >/dev/null
