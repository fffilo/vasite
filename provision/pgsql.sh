#!/usr/bin/env bash

echo "################################"
echo "### pgsql.sh ###################"
echo "################################"

### Install postgresql server
sudo apt-get install -y postgresql postgresql-contrib

### Make postgre accept remote connections
sudo sed -i "s/listen_addresses = .*/listen_addresses = '*'/" /etc/postgresql/current/main/postgresql.conf
