#!/usr/bin/env bash

echo "################################"
echo "### mysql.sh ###################"
echo "################################"

### Install mysql server
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"
sudo apt-get install -y mysql-server

### Backup default config
sudo cp /etc/mysql/my.cnf /etc/mysql/my.cnf.default

### Fix key_buffer warning
sudo sed -ri 's/key_buffer(\s.*)/#key_buffer\1\nkey_buffer_size\1/g' /etc/mysql/my.cnf

### Make MySQL accept remote connections
sudo sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

### Adding a root user for remote connections
echo "USE mysql; UPDATE user SET host = '%' WHERE host = 'vagrant-ubuntu-trusty-64' AND user = 'root'; FLUSH PRIVILEGES;" | mysql --user=root --password=root

### Creating empty database and add user privileges
echo "CREATE DATABASE ${ENVIRONMENT} DEFAULT CHARACTER SET utf8 COLLATE utf8_bin; GRANT ALL PRIVILEGES ON ${ENVIRONMENT}.* TO 'root'@'%'; FLUSH PRIVILEGES;" | mysql --user=root --password=root

### Change root password
#mysqladmin --user=root --password=root password 'newrootpassword'

### Restart server
sudo service mysql restart
