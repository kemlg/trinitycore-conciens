echo "127.0.0.1 `hostname`" | sudo tee -a /etc/hosts
sudo port sync
sudo port install rabbitmq-c mysql56 rabbitmq-server p7zip readline wget scons
sudo port install erlang +ssl
sudo echo "[{rabbit, [{loopback_users, []}]}]." > /opt/local/etc/rabbitmq/rabbitmq.config
sudo /opt/local/lib/rabbitmq/lib/rabbitmq_server-*/sbin/rabbitmq-plugins enable rabbitmq_management
sudo port unload rabbitmq-server
sudo port load rabbitmq-server
cd /tmp/
git clone -b 26compat https://github.com/mongodb/mongo-cxx-driver.git
cd -
cd /tmp/mongo-cxx-driver
mkdir build
cd -
cd /tmp/mongo-cxx-driver/
sudo scons --prefix=/opt/local --extrapath=/opt/local/ --use-system-boost --full --osx-version-min=10.10
cd -
mkdir build
cd build/
cmake ../ -GXcode -DPREFIX=`pwd`/install -DWARNINGS=0 -DTOOLS=1 -DSCRIPTS=1 -DSERVERS=1 -Wno-dev -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++
sudo port install mysql56-server
sudo /opt/local/lib/mysql56/bin/mysql_install_db --user=mysql
sudo /opt/local/share/mysql56/support-files/mysql.server start
/opt/local/lib/mysql56/bin/mysqladmin -u root password 'trinity'
sudo launchctl load -w /Library/LaunchDaemons/org.macports.mysql56-server.plist
sudo port load rabbitmq-server

