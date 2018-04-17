# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_IMAGE_GENERIC = 'debian/jessie64'
CLUSTER_DOMAIN = "example.local"

$config_puppet_agent = <<SCRIPT
if grep -Fq 'puppetmaster.#{CLUSTER_DOMAIN}' /etc/puppetlabs/puppet/puppet.conf
then

  echo "Puppet master is already configured, skipping."

else

  cat <<EOF >> /etc/puppetlabs/puppet/puppet.conf
[main]
server = puppetmaster.#{CLUSTER_DOMAIN}
stringify_facts = true

[agent]
environment = production
runinterval = 30m
show_diff = false
splay = false
preferred_serialization_format = pson
reports = true
EOF

fi
SCRIPT

Vagrant.configure("2") do |config|

# DNS configuration
  config.hostmanager.enabled = true
  config.hostmanager.manage_guest = true

## Puppetmaster
  config.vm.define "puppetmaster" do |node|

    # VM configuration
    node.vm.box = BOX_IMAGE_GENERIC
    node.vm.hostname = "puppetmaster.#{CLUSTER_DOMAIN}"
    node.vm.network "private_network", ip: "10.10.10.10"

    node.hostmanager.aliases = %w(puppet puppetmaster)

    # Lower VM memory
    node.vm.provider :virtualbox do |vb|
      vb.memory = "2048"
    end

    # Provision puppet repo and agent
    node.vm.provision "shell" do |s|
      s.path = "scripts/puppet.sh"
    end

    # Provision puppet server
    node.vm.provision "shell" do |s|
      s.path = "scripts/puppetserver.sh"
    end

    # Add metadata file containing custom facts
    # used for bootstrapping the node
    node.vm.provision "shell" do |s|
      s.path = "scripts/create_metadata.sh"
      s.args   = "puppetmaster"
    end

    # Configure puppet agent
    node.vm.provision "shell", inline: $config_puppet_agent

    # Mount local puppet code inside the puppetmaster
    node.vm.synced_folder "environments", "/srv/puppet/code/environments"

    # Provision the puppet master
    node.vm.provision "puppet" do |puppet|
      puppet.environment = "production"
      puppet.environment_path  = "environments"
      puppet.options = ["--verbose"]
      puppet.hiera_config_path = "environments/production/hiera.yaml"
    end
  end

## Development node
  config.vm.define "node" do |node|

    # Set box images
    node.vm.box = BOX_IMAGE_GENERIC
    node.vm.hostname = "node.#{CLUSTER_DOMAIN}"
    node.vm.network "private_network", ip: "10.10.10.20"

    # Lower VM memory
    node.vm.provider :virtualbox do |vb|
      vb.memory = "1024"
    end

    # Provision puppet repo and agent
    node.vm.provision "shell" do |s|
      s.path = "scripts/puppet.sh"
    end

    # Add metadata file containing custom facts
    # used for bootstrapping the node
    node.vm.provision "shell" do |s|
      s.path = "scripts/create_metadata.sh"
      s.args   = "node"
    end

    # Configure puppet agent
    node.vm.provision "shell", inline: $config_puppet_agent

    # Add metadata file containing custom facts
    # used for bootstrapping the node
    node.vm.provision "shell" do |s|
      s.path = "scripts/setchallengepassword.sh"
      s.args   = ENV['CHALLENGEPASSWORD']
    end
  end
end
