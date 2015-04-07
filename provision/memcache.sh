#!/usr/bin/env bash

echo "################################"
echo "### memcache.sh ################"
echo "################################"

### Install memcached
sudo apt-get install -y memcached php5-memcache

### Backup config
sudo cp /etc/memcached.conf /etc/memcached.conf.default
