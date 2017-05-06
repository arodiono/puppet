# Set vhost configuration
$host = "imageresize"
$domain = 'local'
$url    = "${host}.${domain}"

# update package repo
exec { 'apt-get update':
  command => '/usr/bin/apt-get update',
}


# Prepare my standarts tools
$mytools = ['mc', 'htop', 'ccze', 'git']
package {$mytools: require => Exec['apt-get update'], ensure => 'installed' }


file { '/var/www':
  ensure => 'directory',
}

host { $url:
  ip => '127.0.0.1',
  host_aliases => $host,
  ensure => 'present',
}

# Configure nginx vhost
nginx::vhost {$url:
  path  => '/var/www/web'
}

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

include timezoneset, nginx, mysql, php71