class php71 {
  

  # Prepare my standarts tools for install php7.1
  $phpreq = ['apt-transport-https', 'lsb-release', 'ca-certificates', 'curl']
  package {$phpreq: require => Exec['apt-get update'], ensure => 'installed' }

  # Add dotdeb.org repository
  exec {'sury-repos':
    command => "/bin/echo -e 'deb https://packages.sury.org/php/ jessie main' >> /etc/apt/sources.list",
  }
  exec {'sury-key': 
    require => [ Exec['sury-repos'], Package['curl'] ],
    path    => '/usr/bin',
    command => 'curl https://packages.sury.org/php/apt.gpg | sudo apt-key add -',
  }
  exec { 'sury-include':
    require => [Exec['sury-repos'], Exec['sury-key']],
    command => '/usr/bin/apt-get update',
  }

  # Install the php7.1-fpm 
  package {'php7.1-fpm':
    ensure  => installed,
    require => Exec['sury-include'],
  }
  # Install php7.1 extensions
  $phpextensions = ['php7.1-xdebug','php7.1-curl','php7.1-gd','php7.1-imagick','php7.1-intl','php7.1-mbstring','php7.1-mcrypt','php7.1-pdo-mysql','php7.1-simplexml','php7.1-soap','php7.1-xml','php7.1-xsl','php7.1-zip','php7.1-json','php7.1-iconv']
  package {$phpextensions:
    ensure  => installed,
    require => [Exec['sury-include'], Package['php7.1-fpm']],
  }

  # # Make sure php7.1-fpm is running
  service { 'php7.1-fpm':
    ensure => running,
    require => Package['php7.1-fpm'],
  }

  # XDebug configuration
  file {'php-xdebug' :
    path    => '/etc/php/7.1/mods-available/xdebug.ini',
    ensure  => file,
    group   => 'root',
    require => Package['php7.1-xdebug'],
    source  => 'puppet:///modules/php71/xdebug.ini',
  }

    # Configure php5-fpm pool settings
  file {'php-pool-www':
    notify  => Service['php7.1-fpm'],
    ensure  => file,
    path    =>  '/etc/php/7.1/fpm/pool.d/www.conf',
    require => Package['php7.1-fpm'],
    source  => 'puppet:///modules/php71/www.conf'
  }

}

# Install additional extensions
define php71::extensions($phpextensions) {
  package {$phpextensions:
    ensure  => installed,
    require => Package['php7.1-fpm'],
    notify  => Service['php7.1-fpm'],
  }
}
