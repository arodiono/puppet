class php70 {
  #install curl
  package {'curl':
    ensure  => installed,
  }

  # Add dotdeb.org repository
  exec {'dotdeb-repos':
    command => "/bin/echo -e 'deb http://packages.dotdeb.org jessie all\ndeb-src http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list",
  }
  exec {'dotdeb-key': 
    require => [ Exec['dotdeb-repos'], Package['curl'] ],
    path    => '/usr/bin',
    command => 'curl https://www.dotdeb.org/dotdeb.gpg | sudo apt-key add -',
  }
  exec { 'dotdeb-include':
    require => [Exec['dotdeb-repos'], Exec['dotdeb-key']],
    command => '/usr/bin/apt-get update',
  }

  # Install the php7.0-fpm 
  package {'php7.0-fpm':
    ensure  => installed,
    require => Exec['dotdeb-include'],
  }
  # Install php7.0 extensions
  $phpextensions = ['php7.0-xdebug','php7.0-curl','php7.0-gd','php7.0-imagick','php7.0-intl','php7.0-mbstring','php7.0-mcrypt','php7.0-pdo-mysql','php7.0-simplexml','php7.0-soap','php7.0-xml','php7.0-xsl','php7.0-zip','php7.0-json','php7.0-iconv']
  package {$phpextensions:
    ensure  => installed,
    require => [Exec['dotdeb-include'], Package['php7.0-fpm']],
  }

  # # Make sure php7.0-fpm is running
  service { 'php7.0-fpm':
    ensure => running,
    require => Package['php7.0-fpm'],
  }

  # XDebug configuration
  file {'php-xdebug' :
    path    => '/etc/php/7.0/mods-available/xdebug.ini',
    ensure  => file,
    group   => 'root',
    require => Package['php7.0-xdebug'],
    source  => 'puppet:///modules/php70/xdebug.ini',
  }
  
 exec {'wwwconf':
	command => '/bin/sed -i "s|/run/php/php7.0-fpm.sock|127.0.0.1:9000|g" /etc/php/7.0/fpm/pool.d/www.conf /etc/php/7.0/fpm/pool.d/www.conf',
	require => [Package['php7.0-fpm'], Service['php7.0-fpm']]
 }

}
