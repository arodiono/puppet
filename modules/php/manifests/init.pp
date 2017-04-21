class php {

  # Install the php5-fpm and php5-cli packages
  package { ['php7.1-fpm', 'php-xdebug']:
    ensure => present,
    require => Exec['apt-get update'],
  }

  # Make sure php7.1-fpm is running
  service { 'php7.1-fpm':
    ensure => running,
    require => Package['php7.1-fpm'],
  }

  # XDebug configuration
  file {'php-xdebug' :
    path => '/etc/php/7.1/fpm/conf.d/20-xdebug.ini',
    ensure => file,
    require => Package['php-xdebug'],
    source => 'puppet:///modules/php/files/20-xdebug.ini',
  }
}