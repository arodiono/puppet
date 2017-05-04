class php5 {

  # Install the php5-fpm and php5-cli packages
  package { ['php5-fpm']:
    ensure => installed,
    require => Exec['apt-get update'],
  }

  # Make sure php5-fpm is running
  service { 'php5-fpm':
    ensure => running,
    require => Package['php5-fpm'],
  }

   # Install php7.0 extensions
  $phpextensions = ['php5-xdebug','php5-curl','php-pclzip','php5-gd','php5-mcrypt', 'php5-mysql']
  package {$phpextensions:
    ensure  => installed,
    require => Package['php5-fpm'],
  }

  # Configure php5-fpm pool settings
  file {'php-pool-www':
    notify  => Service['php5-fpm'],
    ensure  => file,
    path    =>  '/etc/php5/fpm/pool.d/www.conf',
    require => Package['php5-fpm'],
    source  => 'puppet:///modules/php5/www.conf'
  }

  # XDebug configuration
  file {'php-xdebug' :
    notify  => Service['php5-fpm'],
    path => '/etc/php5/mods-available/xdebug.ini',
    ensure => file,
    require => Package['php5-xdebug'],
    source => 'puppet:///modules/php5/xdebug.ini',
  }
 
}