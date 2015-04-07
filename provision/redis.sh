#!/usr/bin/env bash

echo "################################"
echo "### redis.sh ###################"
echo "################################"

### Install redis
sudo apt-get install -y redis-server

### Backup config
sudo cp /etc/redis/redis.conf /etc/redis/redis.conf.default
