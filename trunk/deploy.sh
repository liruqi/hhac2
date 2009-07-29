#! /usr/bin/sh

#----------------  Dependencies  ------------------
# gcc, mysql, openssl, subversion, ffmpeg

# ---------------  Install base ruby  ------------------
sudo apt-get install ruby irb rdoc
sudo apt-get install ruby-dev    # mkmf included; gem use mkmf to build mongrel
sudo apt-get install libmysql-ruby
sudo apt-get install libopenssl-ruby

# ---------------  Install rubygems  ------------------
# NOTE:
#  `apt-get install rubygems` cannot properly install rubygems in Debian & Ubuntu
#  we have to install rubygems directly from source
wget http://rubyforge.org/frs/download.php/57643/rubygems-1.3.4.tgz
tar -xvf rubygems-1.3.4.tgz
cd rubygems-1.3.4
sudo ruby setup.rb
sudo ln -s /usr/bin/gem1.8 /usr/bin/gem

# ---------------  Install rails & mongrel  ------------------
sudo gem install rails --version=2.3.2 --include-dependencies
sudo gem install mongrel mongrel_cluster

# ---------------  Checkout the source && setup hhac2  ------------------
svn checkout https://hhac2.googlecode.com/svn/trunk/ hhac2
cd hhac2

# Setup db-user and database for hhac2
chmod u+x ./script/setup_db.sh
./script/setup_db.sh

rake db:migrate

./script/server
