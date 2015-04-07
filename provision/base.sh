#!/usr/bin/env bash

echo "################################"
echo "### base.sh ####################"
echo "################################"

### Retrieve new lists of packages
sudo apt-get update

### Install base packages
sudo apt-get install -y build-essential python-software-properties python-dev python-pip curl git git-core
