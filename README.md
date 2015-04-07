Virtual machine for web development
===================================

Vagrant file with provision bash scripts for easy to set virtual machine.
It targets Ubuntu 14.04LTS.
Just open `Vagrantfile` configure it, and start virtual machine by typing

    vagrant up

By default your virtual's machine IP address is `192.168.33.33` (you can change this in `Vagrantfile`).
You can access your site by typing IP address into your browser.
Your web document root is `/var/www/` which is linked to `./www` on your local computer.
For any other file exchange you can use `/pub/` (or `./pub` on your local computer).

## Dependencies
* [Vagrant](https://www.vagrantup.com/) `1.5.0`+
* [Vitualbox](https://www.virtualbox.org/) or [VMWare Fusion](http://www.vmware.com/products/fusion)
