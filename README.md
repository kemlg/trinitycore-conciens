# ![logo](http://www.trinitycore.org/f/public/style_images/1_trinitycore.png) TrinityCore

[![Issue Stats](http://www.issuestats.com/github/TrinityCore/TrinityCore/badge/issue)](http://www.issuestats.com/github/TrinityCore/TrinityCore) [![Issue Stats](http://www.issuestats.com/github/TrinityCore/TrinityCore/badge/pr)](http://www.issuestats.com/github/TrinityCore/TrinityCore) [![Bountysource](https://www.bountysource.com/badge/tracker?tracker_id=1310)](https://www.bountysource.com/trackers/1310-trinity-core?utm_source=1310&utm_medium=shield&utm_campaign=TRACKER_BADGE)

## Build Status

6.x | 4.3.4 | 3.3.5
:------------: | :------------: | :------------:
[![6.x Build Status](https://travis-ci.org/TrinityCore/TrinityCore.svg?branch=6.x)](https://travis-ci.org/TrinityCore/TrinityCore) | [![4.3.4 Build Status](https://travis-ci.org/TrinityCore/TrinityCore.svg?branch=4.3.4)](https://travis-ci.org/TrinityCore/TrinityCore) | [![3.3.5 Build Status](https://travis-ci.org/TrinityCore/TrinityCore.svg?branch=3.3.5)](https://travis-ci.org/TrinityCore/TrinityCore)
[![Coverity Scan Build Status](https://scan.coverity.com/projects/435/badge.svg)](https://scan.coverity.com/projects/435) | |  [![Coverity Scan Build Status](https://scan.coverity.com/projects/4656/badge.svg)](https://scan.coverity.com/projects/4656)

## Introduction

TrinityCore is a *MMORPG* Framework based mostly in C++.

It is derived from *MaNGOS*, the *Massive Network Game Object Server*, and is
based on the code of that project with extensive changes over time to optimize,
improve and cleanup the codebase at the same time as improving the in-game
mechanics and functionality.

It is completely open source; community involvement is highly encouraged.

If you wish to contribute ideas or code please visit our site linked below or
make pull requests to our [Github repository](https://github.com/TrinityCore/TrinityCore).

For further information on the TrinityCore project, please visit our project
website at [TrinityCore.org](http://www.trinitycore.org).

## Requirements

+ Platform: Linux, Windows or Mac
+ Processor with SSE2 support
+ Boost ≥ 1.49
+ MySQL ≥ 5.1.0
+ CMake ≥ 2.8.11.2 / 2.8.9 (Windows / Linux)
+ OpenSSL ≥ 1.0.0
+ GCC ≥ 4.7.2 (Linux only)
+ MS Visual Studio ≥ 12 (2013) (Windows only)


## Install

Detailed installation guides are available in the [wiki](http://collab.kpsn.org/display/tc/Installation+Guide) for
Windows, Linux and Mac OSX.

### Compile

#### cOncienS flavor

```bash
sudo apt-get install librabbitmq0 libboost-program-options* libboost-system* libboost-thread* libcurl4-openssl-dev p7zip-full vim build-essential autoconf libtool gcc g++ make cmake git-core patch wget links zip unzip unrar openssl libssl-dev mysql-server mysql-client libmysqlclient15-dev libmysql++-dev libreadline6-dev libncurses5-dev zlib1g-dev libbz2-dev libjson-spirit-dev libace-dev libncurses5-dev deluge-console deluge git cmake build-essential libssl-dev rabbitmq-server mongodb-dev screen
wget https://github.com/alanxz/rabbitmq-c/releases/download/v0.5.2/rabbitmq-c-0.5.2.tar.gz
tar -xvzf rabbitmq-c-0.5.2.tar.gz
cd rabbitmq-c-0.5.2
./configure
make
sudo make install
sudo echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list
sudo apt-get update
curl http://www.rabbitmq.com/rabbitmq-signing-key-public.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install rabbitmq-server
sudo rabbitmq-plugins enable rabbitmq_management
sudo vi /etc/rabbitmq/rabbitmq.config
# Add the following: [{rabbit, [{loopback_users, []}]}].
sudo service rabbitmq-server restart
git clone https://github.com/kemlg/trinitycore-conciens
cd trinitycore-conciens
mkdir build
cd build/
cmake ../ -DPREFIX=/home/trinity/server -DCONF_DIR=/home/trinity/server/conf -DLIBSDIR=/home/trinity/server/lib  -DUSE_SFMT=1 -DTOOLS=1 -DSCRIPTS=1 -DSERVERS=1 -DWITH_WARNINGS=1
make
make install
scp sergio@192.168.1.42:WoW.zip .
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
sudo locale-gen en_US.UTF-8
sudo dpkg-reconfigure locales
```

#### Debian Wheezy

```bash
sudo apt-get update
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password trinity'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password trinity'
sudo apt-get install -y librabbitmq0 libboost-filesystem* libboost-program-options* libboost-system* libboost-thread* libcurl4-openssl-dev p7zip-full vim build-essential autoconf libtool gcc g++ make cmake git-core patch wget links zip unzip unrar openssl libssl-dev mysql-server mysql-client libmysqlclient15-dev libmysql++-dev libreadline6-dev libncurses5-dev zlib1g-dev libbz2-dev libjson-spirit-dev libace-dev libncurses5-dev deluge-console deluge git cmake build-essential libssl-dev mongodb-dev libreadline6 libreadline6-dev mongodb-server
wget https://github.com/alanxz/rabbitmq-c/releases/download/v0.5.2/rabbitmq-c-0.5.2.tar.gz
tar -xvzf rabbitmq-c-0.5.2.tar.gz
cd rabbitmq-c-0.5.2
./configure
make
sudo make install
sudo echo "deb http://www.rabbitmq.com/debian/ testing main" > /tmp/rabbitmq.list
sudo mv /tmp/rabbitmq.list /etc/apt/sources.list.d/rabbitmq.list
curl http://www.rabbitmq.com/rabbitmq-signing-key-public.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install rabbitmq-server
sudo rabbitmq-plugins enable rabbitmq_management
echo "[{rabbit, [{loopback_users, []}, {hipe_compile, true}]}]." > /tmp/rabbitmq.config
sudo mv /tmp/rabbitmq.config /etc/rabbitmq/rabbitmq.config
sudo service rabbitmq-server restart
cd
git clone https://github.com/kemlg/trinitycore-conciens
cd trinitycore-conciens
git checkout playerbots
mkdir build
cd build/
cmake ../ -DPREFIX=`pwd`/install -DCONF_DIR=`pwd`/install/conf -DLIBSDIR=`pwd`/install/lib  -DUSE_SFMT=1 -DTOOLS=1 -DSCRIPTS=1 -DSERVERS=1 -DWITH_WARNINGS=1
make -j 4 install
cd
wget http://storage.googleapis.com/conciens/WoW.tar.gz
tar -xvzf WoW.tar.gz
rm -f WoW.tar.gz
wget http://storage.googleapis.com/conciens/gameobject335.zip
unzip gameobject335.zip
rm -f gameobject335.zip
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
sudo locale-gen en_US.UTF-8
```

#### Ubuntu 14.04

```bash
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password trinity'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password trinity'
sudo apt-get update
sudo apt-get install -y cmake librabbitmq1 libboost-dev libboost-all-dev libcurl4-openssl-dev p7zip-full vim build-essential autoconf libtool gcc g++ make cmake git-core patch wget links zip unzip unrar-free openssl libssl-dev mysql-server mysql-client libmysqlclient15-dev libmysql++-dev libreadline6-dev libncurses5-dev zlib1g-dev libbz2-dev libjson-spirit-dev libace-dev libncurses5-dev deluge-console deluge git cmake build-essential libssl-dev rabbitmq-server screen scons
cd /tmp/
wget https://github.com/alanxz/rabbitmq-c/releases/download/v0.5.2/rabbitmq-c-0.5.2.tar.gz
tar -xvzf rabbitmq-c-0.5.2.tar.gz
cd rabbitmq-c-0.5.2
./configure
make
sudo make install
cd -
cd /tmp/
wget http://www.cmake.org/files/v3.2/cmake-3.2.2.tar.gz
tar xf cmake-3.2.2.tar.gz
cd cmake-3.2.2
./configure
make
sudo make install
cd -
cd /tmp/
git clone -b 26compat https://github.com/mongodb/mongo-cxx-driver.git
cd -
cd /tmp/mongo-cxx-driver/
scons --use-system-boost
sudo scons --use-system-boost --full
cd -
sudo rabbitmq-plugins enable rabbitmq_management
echo "[{rabbit, [{loopback_users, []}]}]." | sudo tee /etc/rabbitmq/rabbitmq.config
sudo service rabbitmq-server restart
git clone https://github.com/kemlg/trinitycore-conciens
cd trinitycore-conciens
mkdir build
cd build/
cmake ../ -DPREFIX=/home/trinity/server -DCONF_DIR=/home/trinity/server/conf -DLIBSDIR=/home/trinity/server/lib  -DUSE_SFMT=1 -DTOOLS=1 -DSCRIPTS=1 -DSERVERS=1 -DWITH_WARNINGS=1 -DCMAKE_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/ -DCMAKE_CXX_FLAGS=-std=gnu++11 -DCMAKE_C_FLAGS=-std=gnu99
make
make install
```

#### OSX (using xcode)

Add your machine name to `/etc/hosts`: `127.0.0.1   machine-name`.

Install mysql, rabbit-mq and openSSL version 1.0 or higher. Ignore warnings related to the Erlang version.

```bash
sudo port sync
sudo port install rabbitmq-c mysql56 mongodb rabbitmq-server p7zip readline wget
sudo port install erlang +ssl
sudo echo "[{rabbit, [{loopback_users, []}]}]." > /opt/local/etc/rabbitmq/rabbitmq.config
sudo /opt/local/lib/rabbitmq/lib/rabbitmq_server-3.1.5/sbin/rabbitmq-plugins enable rabbitmq_management
sudo port unload rabbitmq-server
sudo port load rabbitmq-server
sudo port load mongodb
cd /tmp/
wget "https://github.com/cppformat/cppformat/releases/download/1.1.0/cppformat-1.1.0.zip" -O cppformat-1.1.0.zip
unzip -o cppformat-1.1.0.zip
cd cppformat-1.1.0
mkdir build
cd build
cmake ../ -DCMAKE_INSTALL_PREFIX=/opt/local/
make
sudo make install
cd -
cd /tmp/
git clone -b 26compat https://github.com/mongodb/mongo-cxx-driver.git
cd -
cd /tmp/mongo-cxx-driver/build
cmake ../ -DCMAKE_INSTALL_PATH=/opt/local/
make
sudo make install
cd -
```

Create build directory:
```bash
mkdir build
cd build/
```

Generate xcode project configuration and open the project using xcode:
```bash
cmake ../ -GXcode -DPREFIX=`pwd`/install -DWARNINGS=0 -DTOOLS=1 -DSCRIPTS=1 -DSERVERS=1 -Wno-dev -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++
open TrinityCore.xcodeproj/
```

Once in XCode, build the `install` target.

Install the MySQL server:

```bash
sudo port install mysql56-server
sudo /opt/local/lib/mysql56/bin/mysql_install_db --user=mysql
sudo /opt/local/share/mysql56/support-files/mysql.server start
/opt/local/lib/mysql56/bin/mysqladmin -u root password 'trinity'
sudo launchctl load -w /Library/LaunchDaemons/org.macports.mysql56-server.plist
```

Start the message queue and database:

```bash
sudo port load rabbitmq-server
sudo port load mongodb
```

### Install

Download the client for the game (version 3.3.5a).

Download file from
[gameobject335 location](http://filebeam.com/4f1ec0862cdee726b8977ffeabcbe1fc) and uncompress somewhere.

Prepare the following Bash exports:

 * `${REPO}`: the root of this repository.
 * `${INSTALL}`: the directory of the the directory of the installed binaries.
 * `${CLIENT}`: the directory of the client.
 * `${PATCH}`: the directory of the gameobject335 uncompressed directory.
 * `${MYSQL}`: the path to the mysql binary (usually `mysql`, sometimes similar to `/opt/local/lib/mysql56/bin/mysql` in OSX).

```bash
cd ${CLIENT}
cp ${PATCH}/patch-g.mpq Data/
${INSTALL}/bin/mapextractor
cp ${PATCH}/GameObjectDisplayInfo.dbc dbc/
rm -fR Buildings/
${INSTALL}/bin/vmap4extractor
mkdir ${INSTALL}/data
cp -r dbc maps ${INSTALL}/data/
mkdir vmaps
${INSTALL}/bin/vmap4assembler Buildings vmaps
cp -r vmaps ${INSTALL}/data
find Buildings/ -exec cp {} ${INSTALL}/data/vmaps/ \;
cd ${INSTALL}
cd etc/
cp worldserver.conf.dist worldserver.conf
cp authserver.conf.dist authserver.conf
cd /tmp/
wget https://github.com/TrinityCore/TrinityCore/releases/download/TDB335.58/TDB_full_335.58_2015_03_21.7z -O TDB_full_335.58_2015_03_21.7z
7z x TDB_full_335.58_2015_03_21.7z
${MYSQL} -u root -ptrinity < ${REPO}/sql/create/create_mysql.sql
${MYSQL} -u root -ptrinity auth < ${REPO}/sql/base/auth_database.sql 
${MYSQL} -u root -ptrinity characters < ${REPO}/sql/base/characters_database.sql 
find ${REPO}/sql/updates/world/ -exec sh -c '/opt/local/lib/mysql56/bin/mysql -u root -ptrinity world < {}' \;
${MYSQL} -u root -ptrinity characters < ${REPO}/sql/characters_ai_playerbot.sql
${MYSQL} -u root -ptrinity characters < ${REPO}/sql/characters_auctionhousebot.sql
${MYSQL} -u root -ptrinity characters < ${REPO}/sql/characters_ai_playerbot_names.sql
${MYSQL} -u root -ptrinity world < ${PATCH}/gameobjectstrinity.sql
```

### Run

Start the game servers:

```bash
cd ${INSTALL}/data
screen -d -m ../bin/authserver
screen ../bin/worldserver
```

## Reporting issues

Issues can be reported via the [Github issue tracker](https://github.com/TrinityCore/TrinityCore/issues?labels=Branch-3.3.5a).

Please take the time to review existing issues before submitting your own to
prevent duplicates.

In addition, thoroughly read through the [issue tracker guide](http://www.trinitycore.org/f/topic/37-the-trinitycore-issuetracker-and-you/) to ensure
your report contains the required information. Incorrect or poorly formed
reports are wasteful and are subject to deletion.


## Submitting fixes

Fixes are submitted as pull requests via Github. For more information on how to
properly submit a pull request, read the [how-to: maintain a remote fork](http://www.trinitycore.org/f/topic/6037-howto-maintain-a-remote-fork-for-pull-requests-tortoisegit/).


## Copyright

License: GPL 2.0

Read file [COPYING](COPYING)


## Authors &amp; Contributors

Read file [THANKS](THANKS)


## Links

[Site](http://www.trinitycore.org)

[Wiki](http://trinitycore.info)

[Documentation](http://www.trinitycore.net) (powered by Doxygen)

[Forums](http://www.trinitycore.org/f/)
