class opencart {
  include nginx, php5, mysql

  # Create opencart database
  mysql::createdb {'opencart':
    password  => 'secret',
    user      => 'opencart',
    require   => Service['mysql']   
  }

  # Shedule database dump every 15 minutes
  cron { "dbdump":
      command => "mysqldump -u root --password=secret  opencart | gzip > /vagrant/dbbackup/opencart.sql.gz",
      user    => 'root',
      minute  => '*/15',
      require => [
          Package['mysql-server'],
          Service['mysql'],
          Exec['set-mysql-password'],
      ],
  }
  
  # Restore database dupm
  mysql::restore {'opencart':
    password  => 'secret',
    path      => '/vagrant/dbbackup',
    # require   =>  mysql::db['opencart']
  }
}
