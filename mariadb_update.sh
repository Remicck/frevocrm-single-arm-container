service mysql start
mysql -u root -e "update user set plugin='' where user='root';" -D mysql
mysql -u root -e "flush privileges;" -D mysql
