class apache {
	package { 'apache':
	    ensure => 'present',
	    require => Exec['apt-get update'],
  	}
}