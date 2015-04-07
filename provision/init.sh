#!/usr/bin/env bash

echo "################################"
echo "### init.sh ####################"
echo "################################"

### Enable swap
#sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
#sudo /sbin/mkswap /var/swap.1
#sudo /sbin/swapon /var/swap.1

echo "Exporting arguments"
export ENVIRONMENT=${1}
export SWAPSIZE=${2}
export LANGUAGE=${3}
export LC_ALL=${4}
export LC_PAPER=${5}
export LC_ADDRESS=${6}
export LC_MONETARY=${7}
export LC_NUMERIC=${8}
export LC_TELEPHONE=${9}
export LC_IDENTIFICATION=${10}
export LC_MEASUREMENT=${11}
export LC_TIME=${12}
export LC_NAME=${13}
export LANG=${14}
export TIMEZONE=${15}

echo "Saving arguments to current profile"
echo "export ENVIRONMENT=${ENVIRONMENT}" >> ~/.profile
echo "export SWAPSIZE=${SWAPSIZE}" >> ~/.profile
echo "export LANGUAGE=${LANGUAGE}" >> ~/.profile
echo "export LC_ALL=${LC_ALL}" >> ~/.profile
echo "export LC_PAPER=${LC_PAPER}" >> ~/.profile
echo "export LC_ADDRESS=${LC_ADDRESS}" >> ~/.profile
echo "export LC_MONETARY=${LC_MONETARY}" >> ~/.profile
echo "export LC_NUMERIC=${LC_NUMERIC}" >> ~/.profile
echo "export LC_TELEPHONE=${LC_TELEPHONE}" >> ~/.profile
echo "export LC_IDENTIFICATION=${LC_IDENTIFICATION}" >> ~/.profile
echo "export LC_MEASUREMENT=${LC_MEASUREMENT}" >> ~/.profile
echo "export LC_TIME=${LC_TIME}" >> ~/.profile
echo "export LC_NAME=${LC_NAME}" >> ~/.profile
echo "export LANG=${LANG}" >> ~/.profile
echo "export TIMEZONE=${TIMEZONE}" >> ~/.profile

echo "Adding some aliases"
echo "" | sudo tee -a /home/vagrant/.bashrc >/dev/null
echo "# created by vagrant init.sh script" | sudo tee -a /home/vagrant/.bashrc >/dev/null
echo "alias la='ls -lah'" | sudo tee -a /home/vagrant/.bashrc >/dev/null
echo "alias cdd='cd -'" | sudo tee -a /home/vagrant/.bashrc >/dev/null
echo "alias ..='cd ..'" | sudo tee -a /home/vagrant/.bashrc >/dev/null
echo "alias ...='cd ../..'" | sudo tee -a /home/vagrant/.bashrc >/dev/null
echo "alias ....='cd ../../..'" | sudo tee -a /home/vagrant/.bashrc >/dev/null
echo "alias .....='cd ../../../..'" | sudo tee -a /home/vagrant/.bashrc >/dev/null
echo "alias ......='cd ../../../../..'" | sudo tee -a /home/vagrant/.bashrc>/dev/null

echo "Setting environment"
echo "# created by vagrant init.sh script" | sudo tee /etc/profile.d/vagrant.sh >/dev/null
echo "export ENVIRONMENT=\"${ENVIRONMENT}\"" | sudo tee -a /etc/profile.d/vagrant.sh >/dev/null

echo "Setting locale"
echo "# created by vagrant init.sh script" | sudo tee /etc/default/locale >/dev/null
echo "LANGUAGE=${LANGUAGE}" | sudo tee -a /etc/default/locale >/dev/null
echo "LC_ALL=${LC_ALL}" | sudo tee -a /etc/default/locale >/dev/null
echo "LC_PAPER=${LC_PAPER}" | sudo tee -a /etc/default/locale >/dev/null
echo "LC_ADDRESS=${LC_ADDRESS}" | sudo tee -a /etc/default/locale >/dev/null
echo "LC_MONETARY=${LC_MONETARY}" | sudo tee -a /etc/default/locale >/dev/null
echo "LC_NUMERIC=${LC_NUMERIC}" | sudo tee -a /etc/default/locale >/dev/null
echo "LC_TELEPHONE=${LC_TELEPHONE}" | sudo tee -a /etc/default/locale >/dev/null
echo "LC_IDENTIFICATION=${LC_IDENTIFICATION}" | sudo tee -a /etc/default/locale >/dev/null
echo "LC_MEASUREMENT=${LC_MEASUREMENT}" | sudo tee -a /etc/default/locale >/dev/null
echo "LC_TIME=${LC_TIME}" | sudo tee -a /etc/default/locale >/dev/null
echo "LC_NAME=${LC_NAME}" | sudo tee -a /etc/default/locale >/dev/null
echo "LANG=${LANG}" | sudo tee -a /etc/default/locale >/dev/null

echo "Setting timezone"
sudo timedatectl set-timezone $TIMEZONE

echo "Setting host file"
echo "127.0.0.1 ${ENVIRONMENT}" | sudo tee -a /etc/hosts >/dev/null
echo "127.0.0.1 ${ENVIRONMENT}.local" | sudo tee -a /etc/hosts >/dev/null
