class itop {
  include apache, mysql, php70apache

  package {'graphviz':
    ensure  => installed,
  }
  file { '/var/www':
    ensure => 'directory',
  }


$phpextensions = ['php7.0-apcu', 'php5-ldap', 'php-opcache', 'php-pdo', 'php7.0-bz2', 'php7.0-cli', 'php7.0-common', 'php7.0-dev', 'php7.0-gd', 'php7.0-geoip', 'php7.0-igbinary', 'php7.0-imap', 'php7.0-json', 'php7.0-ldap', 'php7.0-mbstring', 'php7.0-mcrypt', 'php7.0-memcached', 'php7.0-msgpack', 'php7.0-mysql', 'php7.0-odbc', 'php7.0-opcache', 'php7.0-readline', 'php7.0-soap', 'php7.0-sybase', 'php7.0-xml', 'php7.0-zip']
  package {$phpextensions:
    ensure  => installed,
    require => [Exec['dotdeb-include'], Package['php7.0']],
  }


# Copy configuration
# apache
  file {'apache-vhost' :
      path    => '/etc/apache2/sites-available/itop.local.conf',
      ensure  => file,
      group   => 'root',
      require => Package['apache2'],
      source  => 'puppet:///modules/itop/itop.local.conf',
      notify  => Service['apache2'],
    }
  exec {'siteenable':
    require => [File['apache-vhost'], Package['apache2']],
    command =>  '/usr/sbin/a2ensite itop.local',
  }
  exec {'apachemodenable':
    require => [Exec['siteenable'], Package['apache2']],
    command =>  '/usr/sbin/a2enmod suexec ssl auth_ntlm_winbind unique_id socache_shmcb include headers security2 rewrite',
  }

# Mysql
  file {'mysql-config' :
      path    => '/etc/mysql/my.cnf',
      ensure  => file,
      group   => 'root',
      require => Package['mysql-server'],
      source  => 'puppet:///modules/itop/my.cnf',
    }
  tidy {'mysql-iblogfile-remove':
    require => File['mysql-config'],
    path  => '/var/lib/mysql',
    recurse => true,
    matches =>  ['ib_logfile?'],
    rmdirs  => false,
    notify  => Service['mysql'],
  }
}
