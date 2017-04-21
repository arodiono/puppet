# execute aptitude update
exec { "apt-get update":
  # path => "/usr/bin",
  command => '/usr/bin/apt-get update'
}

# Prepare my standarts tools 
$mytools = ['mc', 'htop', 'ccze', 'git']
package {$mytools: require => Exec['apt-get update'], ensure => 'installed' }


file { '/var/www/':
  ensure => 'directory',
}

file {'hosts' : 
	path => '/etc/hosts',
	ensure => file,
	source => 'puppet:///files/hosts'
}
include nginx, php, mysql