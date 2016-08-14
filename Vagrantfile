# -*- mode: ruby -*-
# vi: set ft=ruby :

##
# Open AS Communication Gateway
# Vagrantfile 1.0 (14.08.2016)
##

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.hostname = "antispam.local"
  config.vm.network "forwarded_port", guest: 443, host: 8443
  config.vm.network "private_network", ip: "192.168.200.100"
  config.vm.synced_folder ".", "/vagrant"

  config.vm.provision "shell", inline: <<-SHELL
	   echo "***************************************"
           echo "**** Installing Build dependencies ****"
	   echo "***************************************"
	   sudo apt-get -y -q update && sudo apt-get -y -q upgrade
	   sudo apt-get -y -q install dpkg-dev debhelper fakeroot
	   echo "**************************************"
	   echo "**** Building open-as-cgw package ****"
	   echo "**************************************"
	   sudo mkdir -p /tmp/build/open-as-cgw
	   sudo cp -Rf /vagrant/* /tmp/build/open-as-cgw/
	   cd /tmp/build/open-as-cgw
	   sudo dpkg-buildpackage -rfakeroot
	   echo "****************************************"
	   echo "**** Installing open-as-cgw package ****"
	   echo "****************************************"
	   echo "debconf debconf/frontend select noninteractive" | sudo debconf-set-selections
	   echo "mysql-server mysql-server/root_password password" | sudo debconf-set-selections
	   echo "mysql-server mysql-server/root_password_again password" | sudo debconf-set-selections
	   echo "postfix postfix/main_mailer_type select Internet Site" | sudo debconf-set-selections
	   echo "postfix postfix/mailname string antispam.localdomain" | sudo debconf-set-selections
	   sudo apt-get -y -q -f install /tmp/build/*.deb
	   sudo rm -rf /tmp/build
	   sudo service openas-firewall stop
           echo "********************************************"
           echo "****      Installation completed        ****"
	   echo "**** Navigate to https://localhost:8443 ****" 
	   echo "**** on your local machines webbrowser  ****"
	   echo "**** For SSH use the 'vagrant ssh' cmd  ****"
           echo "********************************************"
	SHELL
end