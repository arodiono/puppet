class timezoneset {
	exec{'timezoneset':
		path => '/usr/bin/',
		command => 'timedatectl set-timezone Europe/Kiev',
	}
}