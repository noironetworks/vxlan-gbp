# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "tgraf/vxlan-gbp"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ["modifyvm", :id, "--cpus", "4"]
  end

  config.vm.define "kernel1" do |kernel1|
    kernel1.vm.network "private_network", ip: "20.1.1.10"
    kernel1.vm.provision :shell, path: "bootstrap.sh", args: ["20.1.1.20", "10.1.1.10/24", "30.1.1.10/24"]
  end

  config.vm.define "kernel2" do |kernel2|
    kernel2.vm.network "private_network", ip: "20.1.1.20"
    kernel2.vm.provision :shell, path: "bootstrap.sh", args: ["20.1.1.10", "10.1.1.20/24", "30.1.1.20/24"]
  end

end
