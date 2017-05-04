class itop {
  include nginx, mysql, php70

  package {'graphviz':
    ensure  => installed,
  }

  # Create opencart database
  mysql::createdb {'itop':
    password  => 'secret',
    user      => 'itop',
    require   => Service['mysql']   
  }

  # Shedule database dump every 15 minutes
  cron { "dbdump":
      command => "mysqldump -u root --password=secret  itop | gzip > /vagrant/dbbackup/itop.sql.gz",
      user    => 'root',
      minute  => '*/15',
      require => [
          Package['mysql-server'],
          Service['mysql'],
          Exec['set-mysql-password'],
      ],
  }
  
  # Restore database dupm
  mysql::restore {'itop':
    password  => 'secret',
    path      => '/vagrant/dbbackup',
    # require   =>  mysql::db['itop']
  }
}
