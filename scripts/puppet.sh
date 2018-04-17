## Install puppet.

export DEBIAN_FRONTEND=noninteractive

DISTRO_CODENAME=`lsb_release -c | awk {'print $2'}`

# Check if the puppet release package is installed
if dpkg-query -W -f'${Status}' "puppetlabs-release-pc1" 2>/dev/null | grep -q "ok installed"
then
  echo "Puppet release package already installed, skipping"
else
  # Download and install "release” package.
  wget https://apt.puppetlabs.com/puppetlabs-release-pc1-${DISTRO_CODENAME}.deb
  dpkg -i puppetlabs-release-pc1-${DISTRO_CODENAME}.deb
  rm puppetlabs-release-pc1-${DISTRO_CODENAME}.deb

  # Update apt.
  apt-get update
fi

# Check if the puppet release package is installed
if dpkg-query -W -f'${Status}' "puppet-agent" 2>/dev/null | grep -q "ok installed"
then
  echo "Puppet agent already installed, skipping"
else
  # Install Puppet.
  apt-get install puppet-agent

  # Add /opt/puppetlabs/bin to the path for sh compatible users
  if [ ! -f /etc/profile.d/puppet-agent.sh ]
  then
  cat <<EOF >> /etc/profile.d/puppet-agent.sh
# Add /opt/puppetlabs/bin to the path for sh compatible users
if ! echo $PATH | grep -q /opt/puppetlabs/bin ; then
    export PATH=$PATH:/opt/puppetlabs/bin
fi
EOF
fi
fi

# Disable puppet service
systemctl disable puppet
