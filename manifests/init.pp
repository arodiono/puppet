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

host { '220market.local':
	ip => '127.0.0.1',
	host_aliases => '220market',
	ensure => 'present',
 }

include timezoneset, nginx, mysql, php5