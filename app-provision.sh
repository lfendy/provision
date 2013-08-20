#!/bin/sh

# make sure yum caches
sed -i 's/keepcache=0/keepcache=1/g' /etc/yum.conf

# Install Git.
yum install -y git
# Pull down rbenv.
git clone https://github.com/sstephenson/rbenv.git /usr/local/.rbenv
# Pull down ruby-build.
git clone https://github.com/sstephenson/ruby-build.git /usr/local/.rbenv/plugins/ruby-build
# Set rbenv root path.
sed -i 's/export RBENV_ROOT=\/usr\/local\/.rbenv//g' /etc/bashrc
echo 'export RBENV_ROOT=/usr/local/.rbenv' >> /etc/bashrc
# Add rbenv to path.
sed -i 's/export PATH="\/usr\/local\/.rbenv\/bin:$PATH"//g' /etc/bashrc
echo 'export PATH="/usr/local/.rbenv/bin:$PATH"' >> /etc/bashrc
# Initalise rbenv on login shell
sed -i 's/eval "$(rbenv init -)"//g' /etc/bashrc
echo 'eval "$(rbenv init -)"' >> /etc/bashrc

source /etc/bashrc

# Install Ruby dependencies.
yum install -y automake zlib zlib-devel readline libyaml libyaml-devel readline-devel ncurses ncurses-devel gdbm gdbm-devel glibc-devel tcl-devel gcc unzip openssl-devel db4-devel byacc make libffi-devel

# Install Ruby and set it default (global).
RUBY_BUILD_CACHE_PATH=/var/cache/wget/ rbenv install 2.0.0-p247
rbenv global 2.0.0-p247
gem install bundler --no-ri --no-rdoc

# Rebuild the shim executables.
rbenv rehash

# Allow all users to read write execute rbenv
chmod -R 777 /usr/local/.rbenv

#Install Apache.
yum install -y httpd
# Install Passenger.
gem install passenger --no-ri --no-rdoc
# Install dependencies for Passenger.
yum install -y curl-devel httpd-devel apr-devel apr-util-devel
# Install Apache module for Passenger.
passenger-install-apache2-module --auto
# Edit Apache config file.
sed -i "s/^.*rbenv.*//g" /etc/httpd/conf/httpd.conf
echo 'LoadModule passenger_module /usr/local/.rbenv/versions/2.0.0-p247/lib/ruby/gems/2.0.0/gems/passenger-4.0.14/buildout/apache2/mod_passenger.so' >> /etc/httpd/conf/httpd.conf
echo 'PassengerRoot /usr/local/.rbenv/versions/2.0.0-p247/lib/ruby/gems/2.0.0/gems/passenger-4.0.14' >> /etc/httpd/conf/httpd.conf
echo 'PassengerDefaultRuby /usr/local/.rbenv/versions/2.0.0-p247/bin/ruby' >> /etc/httpd/conf/httpd.conf
# Retstart the Apache service.
service httpd restart