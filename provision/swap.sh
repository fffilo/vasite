#!/usr/bin/env bash

echo "################################"
echo "### swap.sh ####################"
echo "################################"

# taken from https://programmaticponderings.wordpress.com/2013/12/19/scripting-linux-swap-space/

# does the swap file already exist?
grep -q "swapfile" /etc/fstab

# if not then create it
if [ $? -ne 0 ]; then
	sudo fallocate -l ${SWAPSIZE}M /swapfile
	sudo chmod 600 /swapfile
	sudo mkswap /swapfile
	sudo swapon /swapfile
	echo "/swapfile none swap defaults 0 0" | sudo tee -a /etc/fstab >/dev/null
else
	echo "Swapfile found. No changes made."
fi

# output results to terminal
#cat /proc/swaps
#cat /proc/meminfo | grep Swap
