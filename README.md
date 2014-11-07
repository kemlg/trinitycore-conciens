# ![logo](http://www.trinitycore.org/f/public/style_images/1_trinitycore.png) TrinityCore

[![Coverity Scan Build Status](https://scan.coverity.com/projects/435/badge.svg)](https://scan.coverity.com/projects/435) 
[![Bountysource](https://www.bountysource.com/badge/tracker?tracker_id=1310)](https://www.bountysource.com/trackers/1310-trinity-core?utm_source=1310&utm_medium=shield&utm_campaign=TRACKER_BADGE)  
`3.3.5`: [![3.3.5 Build Status](https://travis-ci.org/TrinityCore/TrinityCore.svg?branch=master)](https://travis-ci.org/TrinityCore/TrinityCore)
`4.3.4`: [![4.3.4 Build Status](https://travis-ci.org/TrinityCore/TrinityCore.svg?branch=4.3.4)](https://travis-ci.org/TrinityCore/TrinityCore)

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

Detailed installation guides are available in the wiki for
[Windows](http://collab.kpsn.org/display/tc/Win),
[Linux](http://collab.kpsn.org/display/tc/Linux) and
[Mac OSX](http://collab.kpsn.org/display/tc/Mac).

## Install: cOncienS flavor

```bash
sudo apt-get install librabbitmq0 libboost-program-options* libboost-system* libboost-thread* libcurl4-openssl-dev p7zip-full vim build-essential autoconf libtool gcc g++ make cmake git-core patch wget links zip unzip unrar openssl libssl-dev mysql-server mysql-client libmysqlclient15-dev libmysql++-dev libreadline6-dev libncurses5-dev zlib1g-dev libbz2-dev libjson-spirit-dev libace-dev libncurses5-dev deluge-console deluge git cmake build-essential libssl-dev rabbitmq-server mongodb-dev
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
cd WoW/
cd Data/
cp ../../gameobject335/patch-g.mpq .
cd ..
~/server/bin/mapextractor
cp ~/gameobject335/GameObjectDisplayInfo.dbc dbc/
rm -fR Buildings/
~/server/bin/vmap4extractor
mkdir ~/server/data
cp -r dbc maps ~/server/data/
mkdir vmaps
~/server/bin/vmap4assembler Buildings vmaps
cp -r vmaps ~/server/data
cp Buildings/* ~/server/data/vmaps/
cd
cd server/
cd conf/
cp worldserver.conf.dist worldserver.conf
cp authserver.conf.dist authserver.conf
# Configure DB and BindIP
vi worldserver.conf
vi authserver.conf
# Configure realm, e.g. insert into realmlist(id,name,address,localAddress,localSubnetMask,port,icon,flag,timezone,allowedSecurityLevel,population,gamebuild) values(1,"Trinity","130.211.62.241","10.240.183.175","255.255.0.0",8085,0,2,1,0,0,12340);
mysql -u root -p auth
cd
wget http://www.trinitycore.org/f/files/getdownload/1266-legacy-tdb-335-full/
mv index.html TDB_full_335.57_2014_10_19.7z
7z x TDB_full_335.57_2014_10_19.7z
mysql -u root -p < trinitycore-conciens/sql/create/create_mysql.sql
mysql -u root -p auth < trinitycore-conciens/sql/base/auth_database.sql 
mysql -u root -p characters < trinitycore-conciens/sql/base/characters_database.sql 
mysql -u root -p world < TDB_full_335.57_2014_10_19.sql
mysql -u root -p world < trinitycore-conciens/sql/updates/world/2014_10*.sql
mysql -u root -p characters < trinitycore-conciens/sql/characters_ai_playerbot.sql
mysql -u root -p characters < trinitycore-conciens/sql/characters_auctionhousebot.sql
mysql -u root -p characters < trinitycore-conciens/sql/characters_ai_playerbot_names.sql
cd
```

## Instructions for developing in XCode

```bash
sudo port install rabbitmq-c mongo-cxx-driver mysql56
cd build/
cmake ../ -GXcode -DREADLINE_INCLUDE_DIR=/opt/local/include -DREADLINE_LIBRARY=/opt/local/lib/libreadline.dylib -DACE_INCLUDE_DIR=/opt/local/include -DACE_LIBRARY=/opt/local/lib/libACE.a -DPREFIX=/opt/trinitycore -DWARNINGS=0 -DOPENSSL_INCLUDE_DIR=/opt/local/include -DOPENSSL_LIBRARY=/opt/local/lib/libssl.a -DMYSQL_INCLUDE_DIR=/opt/local/include/mysql56/ -DMYSQL_LIBRARY=/opt/local/lib/mysql56/mysql/libmysqlclient.a -DTOOLS=1 -DSCRIPTS=1 -DSERVERS=1
open TrinityCore.xcodeproj/
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
