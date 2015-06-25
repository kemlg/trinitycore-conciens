#!/bin/sh

sudo port sync
sudo port install rabbitmq-c mysql56 mysql56-server mongodb rabbitmq-server p7zip readline wget scons gcc47 gcc_select
sudo -u _mysql /opt/local/lib/mysql56/bin/mysql_install_db
sudo port load mysql56-server
/opt/local/lib/mysql56/bin/mysqladmin -u root password 'trinity'
sudo port select gcc mp-gcc47
sudo port install erlang +ssl
sudo echo "[{rabbit, [{loopback_users, []}]}]." > /opt/local/etc/rabbitmq/rabbitmq.config
sudo /opt/local/lib/rabbitmq/lib/rabbitmq_server-3.1.5/sbin/rabbitmq-plugins enable rabbitmq_management
sudo port unload rabbitmq-server
sudo port load rabbitmq-server
sudo port load mongodb
cd /tmp/
sudo rm -fR mongo-cxx-driver
git clone -b 26compat https://github.com/mongodb/mongo-cxx-driver.git
cd -
cd /tmp/mongo-cxx-driver
sudo scons --osx-version-min=10.10 --sharedclient --use-system-boost --full --extrapath=/opt/local --prefix=/opt/local/ install-mongoclient
cd -

rm -fR build
mkdir build
cd build/

cmake ../ -GXcode -DPREFIX=`pwd`/install -DWARNINGS=0 -DTOOLS=1 -DSCRIPTS=1 -DSERVERS=1 -Wno-dev -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++

