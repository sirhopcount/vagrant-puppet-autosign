# Class: profiles::puppet_server
class profiles::puppet_server {

  # Configure puppetserver
  class { 'puppetserver':
    config => {
      'java_args' => {
        'xms'         => '1G',
        'xmx'         => '1G',
        'maxpermsize' => '512m',
      },
    },
  }

  # Enable autosign in config
  ini_setting { 'autosign':
    ensure  => present,
    path    => $settings::config,
    section => 'master',
    setting => 'autosign',
    value   => '/opt/puppetlabs/puppet/bin/autosign-validator',
    notify  => Service['puppetserver'],
  }

  # Configure autosign
  class { '::autosign':
    ensure => 'latest',
    config => {
      'general' => {
        'loglevel' => 'INFO',
      },
      'jwt_token' => {
        'secret'   => 'supersecretpassword',
        'validity' => '31556926',
      }
    }
  }
}
