#!/bin/bash
# add to crontab task "*/15 * * * * /vagrant/provision/mysqldump.sh"
# mysqldump -u root --password=secret --all-databases | gzip > /vagrant/mysql/portfolio.sql.gz
# mysqldump -u root --password=secret  homestead | gzip > /vagrant/mysql/homestead.sql.gz