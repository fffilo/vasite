# -*- mode: ruby -*-
# vi: set ft=ruby :

# Your configuration name
ENVIRONMENT = "vasite"

# Server settings
SERVER_CPUS = "1"
SERVER_MEMORY = "512"
SERVER_SWAP = "512"
SERVER_NETIP = "192.168.33.33"

# Localization settings
LANGUAGE = "en_US.UTF-8"
LC_ALL = "en_US.UTF-8"
LC_PAPER = "hr_HR.UTF-8"
LC_ADDRESS = "hr_HR.UTF-8"
LC_MONETARY = "hr_HR.UTF-8"
LC_NUMERIC = "hr_HR.UTF-8"
LC_TELEPHONE = "hr_HR.UTF-8"
LC_IDENTIFICATION = "hr_HR.UTF-8"
LC_MEASUREMENT = "hr_HR.UTF-8"
LC_TIME = "hr_HR.UTF-8"
LC_NAME = "hr_HR.UTF-8"
LANG = "en_US.UTF-8"
TIMEZONE = "Europe/Zagreb"

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
API_VERSION = "2"

Vagrant.configure(API_VERSION) do |config|

	# Every Vagrant virtual environment requires a box to build off of.
	config.vm.box = "trusty64"

	# The url from where the 'config.vm.box' box will be fetched if it
	# doesn't already exist on the user's system.
	config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

	# Configure synced folders on the machine, so that folders on your
	# host machine can be synced to and from the guest machine
	config.vm.synced_folder "./pub", "/pub", owner: "vagrant", group: "vagrant"
	config.vm.synced_folder "./www", "/www", owner: "www-data", group: "www-data"

	# If using VirtualBox
	#config.vm.provider "virtualbox" do |vb|

		# Set server memory
		#vb.memory = SERVER_MEMORY

		# Set server cpus
		#vb.cpus = SERVER_CPUS

		# Set the timesync threshold to 10 seconds, instead of the default 20 minutes.
		# If the clock gets more than 15 minutes out of sync (due to your laptop going
		# to sleep for instance, then some 3rd party services will reject requests.
		#vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]

	#end

	# Create a private network, which allows host-only access to the machine
	# using a specific IP.
	config.vm.network "private_network", ip: SERVER_NETIP

	# Provisioning with shell (do not edit this)
	config.vm.provision "shell", path: "./provision/init.sh", args: [ ENVIRONMENT, SERVER_SWAP, LANGUAGE, LC_ALL, LC_PAPER, LC_ADDRESS, LC_MONETARY, LC_NUMERIC, LC_TELEPHONE, LC_IDENTIFICATION, LC_MEASUREMENT, LC_TIME, LC_NAME, LANG, TIMEZONE ]
	config.vm.provision "shell", path: "./provision/swap.sh"
	config.vm.provision "shell", path: "./provision/base.sh"

	# Webservers
	#config.vm.provision "shell", path: "./provision/apache.sh"
	config.vm.provision "shell", path: "./provision/nginx.sh"

	# PHP scripting language
	config.vm.provision "shell", path: "./provision/php.sh"

	# Databases
	config.vm.provision "shell", path: "./provision/mysql.sh"
	#config.vm.provision "shell", path: "./provision/pgsql.sh"
	#config.vm.provision "shell", path: "./provision/sqlite.sh"

	# Other packages, modules, frameworks, tools...
	config.vm.provision "shell", path: "./provision/phpmyadmin.sh"
	config.vm.provision "shell", path: "./provision/memcache.sh"
	#config.vm.provision "shell", path: "./provision/redis.sh"
	#config.vm.provision "shell", path: "./provision/imagemagick.sh"
	#config.vm.provision "shell", path: "./provision/nodejs.sh"
	#config.vm.provision "shell", path: "./provision/grunt.sh"
	#config.vm.provision "shell", path: "./provision/phantomjs.sh"
	#config.vm.provision "shell", path: "./provision/wordpress.sh"
	#config.vm.provision "shell", path: "./provision/laravel.sh"

	# Your own scripts
	config.vm.provision "shell", path: "./provision/extras.sh"

end
