# Install composer
 
class composer::install {
 
	# if ($needinstallcurl == true) {
	# 	package { "curl": 
	# 	 ensure => installed
	# 	}
	# }

  exec { 'install composer':
  	path	=> '/tmp',
    command => '/usr/bin/curl -sS https://getcomposer.org/installer | /usr/bin/php && sudo mv composer.phar /usr/local/bin/composer',
    require => Package['curl'],
  }
 
}