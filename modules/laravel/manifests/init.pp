class laravel {
  include nginx, php70, mysql

  # Create opencart database
  mysql::createdb {'homestead':
    password  => 'secret',
    user      => 'homestead',
    require   => Service['mysql']   
  }

  # Shedule database dump every 15 minutes
  cron { "dbdump":
      command => "mysqldump -u root --password=secret  homestead | gzip > /vagrant/mysqldump/homestead.sql.gz",
      user    => 'root',
      minute  => '*/15',
      require => [
          Package['mysql-server'],
          Service['mysql'],
          Exec['set-mysql-password'],
      ],
  }
  
  # Restore database dupm
  mysql::restore {'homestead':
    password  => 'secret',
    path      => '/vagrant/mysqldump',
  }
}
