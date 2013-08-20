#!/bin/sh

# make sure yum caches
sed -i 's/keepcache=0/keepcache=1/g' /etc/yum.conf

# Install PostgreSQL repository.
rpm -Uvh http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-centos92-9.2-6.noarch.rpm

# Install PostgreSQL.
yum install -y postgresql92 postgresql92-server postgresql92-contrib
# Change the password for the default Linux user.
# echo "p05t61235" | passwd postgres --stdin
# Initialise the database.
su - postgres -c /usr/pgsql-9.2/bin/initdb
# Change the PostgreSQL configuration: listen to any remote addresses.
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /var/lib/pgsql/9.2/data/postgresql.conf
# Change the PostgreSQL configuration: uncomment the correct port.
sed -i "s/#port = /port = /" /var/lib/pgsql/9.2/data/postgresql.conf
# Change the PostgreSQL configuration: amend host connections.
sed -i "s/#host\s\+replication\s\+postgres\s\+::1\/128\s\+trust/host all all 0.0.0.0\/0 md5/" /var/lib/pgsql/9.2/data/pg_hba.conf
# Start PostgreSQL.
service postgresql-9.2 start


# Install TMux.
rpm -Uvh http://pkgs.repoforge.org/tmux/tmux-1.6-1.el6.rf.x86_64.rpm

# CREATE ROLE cashbook WITH SUPERUSER LOGIN PASSWORD 'c45h13001<';