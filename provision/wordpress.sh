#!/usr/bin/env bash

echo "################################"
echo "### wordpress.sh ###############"
echo "################################"

### Empty docroot
sudo rm -rf /www/*
find /www -type f -print0 | xargs -0 sudo rm >/dev/null 2>&1
find /www -mindepth 1 -maxdepth 1 -type d -print0 | xargs -0 sudo rm -rf >/dev/null 2>&1

### Install latest wordpress
git clone https://github.com/WordPress/WordPress.git /www
rm /www/.git -rf
