VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "CentOS64_64"
  config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130427.box"

  config.vm.define :db do |db|
    db.vm.provision :shell, :path => "db-provision.sh"
    db.vm.network :forwarded_port, :guest => 22, :host => 7000
  end

  config.vm.define :app do |app|
    app.vm.provision :shell, :path => "app-provision.sh"
    app.vm.network :forwarded_port, :guest => 22, :host => 7001
  end

end
