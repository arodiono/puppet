class apache {
  	$mytools = ['apache2', 'apache2-bin', 'apache2-data', 'apache2-utils', 'libapache2-mod-auth-ntlm-winbind', 'libapache2-mod-evasive', 'libapache2-mod-php7.0', 'libapache2-mod-security2', 'libapache2-modsecurity', 'libapr1:amd64', 'libaprutil1:amd64', 'libaprutil1-dbd-sqlite3:amd64', 'libaprutil1-ldap:amd64']
	package {$mytools: require => Exec['apt-get update'], ensure => 'installed' }
}
class php70apache {
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
  package {['php7.0','php7.0-xdebug']:
    ensure  => installed,
    require => Exec['dotdeb-include'],
  }
  # Install php7.0 extensions
  $phpextensions = ['php7.0-apcu', 'php7.0-bz2', 'php7.0-cli', 'php7.0-common', 'php7.0-dev', 'php7.0-gd', 'php7.0-geoip', 'php7.0-igbinary', 'php7.0-imap', 'php7.0-json', 'php7.0-ldap', 'php7.0-mbstring', 'php7.0-mcrypt', 'php7.0-memcached', 'php7.0-msgpack', 'php7.0-mysql', 'php7.0-odbc', 'php7.0-opcache', 'php7.0-readline', 'php7.0-soap', 'php7.0-sybase', 'php7.0-xml', 'php7.0-zip']
  package {$phpextensions:
    ensure  => installed,
    require => [Exec['dotdeb-include'], Package['php7.0']],
  }


  # XDebug configuration
  file {'php-xdebug' :
    path    => '/etc/php/7.0/mods-available/xdebug.ini',
    ensure  => file,
    group   => 'root',
    require => Package['php7.0-xdebug'],
    source  => 'puppet:///modules/php70/xdebug.ini',
  }
  
  #  exec {'wwwconf':
  # 	command => '/bin/sed -i "s|/run/php/php7.0-fpm.sock|127.0.0.1:9000|g" /etc/php/7.0/fpm/pool.d/www.conf',
  # 	require => [Package['php7.0-fpm'], Service['php7.0-fpm']]
  #  }
  # # Configure php5-fpm pool settings
  # file {'php-pool-www':
  #   notify  => Service['php7.0-fpm'],
  #   ensure  => file,
  #   path    =>  '/etc/php/7.0/fpm/pool.d/www.conf',
  #   require => Package['php7.0-fpm'],
  #   source  => 'puppet:///modules/php70/www.conf'
  # }

}