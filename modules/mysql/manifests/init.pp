class mysql {

  # Install mysql
  package { ['mysql-server']:
    ensure => present,
    require => Exec['apt-get update'],
  }

  # Check mysql run
  service { 'mysql':
    ensure  => running,
    require => Package['mysql-server'],
  }

  # # Use a custom mysql configuration file
  # file { '/etc/mysql/my.cnf':
  #   source  => 'puppet:///modules/mysql/my.cnf',
  #   require => Package['mysql-server'],
  #   notify  => Service['mysql'],
  # }

}

#Prepare Database
define mysql::createdb($user, $password) {
    # Set the root password
    exec { 'set-mysql-password':
      unless  => 'mysqladmin -uroot -proot status',
      command => "mysqladmin -uroot password ${password}",
      path    => ['/bin', '/usr/bin'],
      require => Service['mysql'],
    }
    
    #Create Database
    exec { "create-${name}-db":
      unless => "/usr/bin/mysql -uroot ${name}",
      command => "/usr/bin/mysql -uroot -p${password} -e \"create database ${name};\"",
      require => [Service['mysql'], Exec['set-mysql-password']],
    }
    
    #Grant previlegies to database
    exec { "grant-${name}-db":
      unless => "/usr/bin/mysql -u${user} -p${password} ${name}",
      command => "/usr/bin/mysql -uroot -p${password} -e \"grant all on ${name}.* to ${user}@localhost identified by '$password';\"",
      require => [Service['mysql'], Exec['set-mysql-password'],Exec["create-${name}-db"]]
    }
    # #Grant previlegies to remote access to sql with root
    # exec { "root-remote":
    #   command => "/usr/bin/mysql -uroot -p${password} -e \"grant all on *.* to root@% identified by '$password';\"",
    #   require => [Service['mysql'], Exec['set-mysql-password'],Exec["create-${name}-db"]]
    # }
}

# Restore Dump of database
define mysql::restore($path, $password) {
  #Check is file exist in the path
  exec {"check-presence":
    command => '/bin/true',
    onlyif => "/usr/bin/test -e ${path}/${name}.sql.gz"
  }

  # Restore database dump 
  exec {'restore-dump':
    require => Exec['check-presence'],
    command => "/bin/gunzip < ${path}/${name}.sql.gz | mysql -u root --password=${password} ${name}"
  }
}
define mysql::remoteaccess () {
  exec {"set-bind":
      require => Package['mysql-server'],
      command => "/bin/sed -i \"s|127.0.0.1|${name}|g\" /etc/mysql/my.cnf",
  }
}