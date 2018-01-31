# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'hashicorp/precise64'
  config.vm.network :forwarded_port, guest: 80, host: 8085
  config.ssh.forward_agent = true
  config.vbguest.auto_update = true
  config.omnibus.chef_version = '11.16.4'
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = %w( cookbooks site-cookbooks )
    chef.provisioning_path = '/tmp/vagrant-chef'
    chef.add_role 'vagrant'
  end
end
