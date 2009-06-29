#! /usr/bin/sh
sudo apt-get install ruby irb rdoc

wget http://rubyforge.org/frs/download.php/57643/rubygems-1.3.4.tgz
tar -xvf rubygems-1.3.4.tgz
cd rubygems-1.3.4.tgz
sudo ruby setup.rb
ln -s /usr/bin/gem1.8 /usr/bin/gem

sudo apt-get install openssl libopenssl-ruby


gem install rails --include-dependencies
#gem install mongrel


svn checkout https://hhac2.googlecode.com/svn/trunk/ hhac2 
cd hhac2

mysql -uroot -pgogogo -e "CREATE USER hhac@'localhost' IDENTIFIED BY 'iamharmless';"
mysql -uroot -p -e "CREATE DATABASE IF NOT EXISTS hhac2 CHARACTER SET utf8"
mysql -uroot -p -e "GRANT ALL PRIVILEGES ON hhac2.* TO hhac"

rake db:migrate

./script/server

