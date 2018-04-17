## Install puppet server

export DEBIAN_FRONTEND=noninteractive

DISTRO_CODENAME=`lsb_release -c | awk {'print $2'}`

# Check if puppetserver is installed
if dpkg-query -W -f'${Status}' "puppetserver" 2>/dev/null | grep -q "ok installed"
then 
  echo "Puppet server already installed, skipping"
else
  echo "Installing puppet server"
  apt-get -y install puppetserver

  # Create directory voor puppet code
  if [ ! -f /srv/puppet/code ]; then
    mkdir -p /srv/puppet/code
  fi
fi
