VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "CentOS64_64"
  config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130427.box"

  config.vm.define :db do |db|
    db.vm.network :private_network, ip: "192.168.56.102"
    db.vm.provision :shell, :path => "db-provision.sh"
    db.vm.network :forwarded_port, :guest => 5432, :host => 7050
    db.vm.synced_folder "cache/yum", "/var/cache/yum"
    db.vm.synced_folder "cache/wget", "/var/cache/wget"
  end

  config.vm.define :app do |app|
    app.vm.network :private_network, ip: "192.168.56.101"
    app.vm.provision :shell, :path => "app-provision.sh"
    app.vm.synced_folder "cache/yum", "/var/cache/yum"
    app.vm.synced_folder "cache/wget", "/var/cache/wget"
    app.vm.synced_folder "cache/scripts", "/var/cache/scripts"
  end

  config.vm.provider "virtualbox" do |step|
    step.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
    step.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
  end

end
