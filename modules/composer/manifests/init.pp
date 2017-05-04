class composer{
	Package {'php7.0-cli':
		ensure	=> installed,
	}
	exec {'download':
		command	=> '/usr/bin/php -r "copy(\'https://getcomposer.org/installer\', \'composer-setup.php\');"',
		require	=> Package['php7.0-cli']
	}

	exec {'testchacksum':
		command	=> '/usr/bin/php -r "if (hash_file(\'SHA384\', \'composer-setup.php\') === \'669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410\') { echo \'Installer verified\'; } else { echo \'Installer corrupt\'; unlink(\'composer-setup.php\); } echo PHP_EOL;"',
		require	=> Exec['download'],
	}

	exec {'install':
		command	=> "/usr/bin/php composer-setup.php --install-dir=/usr/bin --filename=${name}",
		require	=> Exec['testchacksum'],
	}

	exec {'unlink':
		require	=> Exec['install'],
		command	=> '/usr/bin/php -r "unlink(\'composer-setup.php\');"'
	}

}
