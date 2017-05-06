class nginx {

  # Install the nginx package. This relies on apt-get update
  package { 'nginx':
    ensure => 'present',
    require => Exec['apt-get update'],
  }

  # Make sure that the nginx service is running
  service { 'nginx':
    ensure => running,
    require => Package['nginx'],
  }

  # Add a vhost template
  file { 'vagrant-nginx':
    path => '/etc/nginx/sites-available/vhost',
    ensure => file,
    require => Package['nginx'],
    source => 'puppet:///modules/nginx/vhost',
  }

  # Disable the default nginx vhost
  file { 'default-nginx-disable':
    path => '/etc/nginx/sites-enabled/default',
    ensure => absent,
    require => Package['nginx'],
  }

  # Symlink our vhost in sites-enabled to enable it
  file { 'vagrant-nginx-enable':
    path => '/etc/nginx/sites-enabled/vhost',
    target => '/etc/nginx/sites-available/vhost',
    ensure => link,
    notify => Service['nginx'],
    require => [
      File['vagrant-nginx'],
      File['default-nginx-disable'],
    ],
  }
}

define nginx::vhost ($path){

  exec {'vhostset':
    command => "/bin/sed -i \"s|vhost.local|${name}|g\" /etc/nginx/sites-available/vhost",
    require => [Package['nginx'], File['vagrant-nginx']],
    
  }
  exec {'vhostpathset':
    require => Exec['vhostset'],
    command => "/bin/sed -i \"s|/var/www/web|${path}|g\" /etc/nginx/sites-available/vhost",
    notify  => Service['nginx'],
  }

}
