#!/bin/bash

# # MySQL restore database
# gunzip < /vagrant/mysql/homestead.sql.gz | mysql -u root --password=secret homestead

# # setupda crontab dump databases
# crontab -l > /tmp/mycron
# echo "*/15 * * * * /vagrant/provision/mysqldump.sh" >> /tmp/mycron
# crontab /tmp/mycron
# rm /tmp/mycron