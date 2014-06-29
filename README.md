# ![logo](https://community.trinitycore.org/public/style_images/1_trinitycore.png) TrinityCore (3.3.5)

[![Average time to resolve an issue](https://isitmaintained.com/badge/resolution/TrinityCore/TrinityCore.svg)](https://isitmaintained.com/project/TrinityCore/TrinityCore "Average time to resolve an issue") [![Percentage of issues still open](https://isitmaintained.com/badge/open/TrinityCore/TrinityCore.svg)](https://isitmaintained.com/project/TrinityCore/TrinityCore "Percentage of issues still open")

## Build Status

master | 3.3.5
:------------: | :------------:
[![master Build Status](https://travis-ci.org/TrinityCore/TrinityCore.svg?branch=master)](https://travis-ci.org/TrinityCore/TrinityCore) | [![3.3.5 Build Status](https://travis-ci.org/TrinityCore/TrinityCore.svg?branch=3.3.5)](https://travis-ci.org/TrinityCore/TrinityCore)
[![master Build status](https://ci.appveyor.com/api/projects/status/54d0u1fxe50ad80o/branch/master?svg=true)](https://ci.appveyor.com/project/DDuarte/trinitycore/branch/master) | [![Build status](https://ci.appveyor.com/api/projects/status/54d0u1fxe50ad80o/branch/3.3.5?svg=true)](https://ci.appveyor.com/project/DDuarte/trinitycore/branch/3.3.5)
[![Coverity Scan Build Status](https://scan.coverity.com/projects/435/badge.svg)](https://scan.coverity.com/projects/435) | [![Coverity Scan Build Status](https://scan.coverity.com/projects/4656/badge.svg)](https://scan.coverity.com/projects/4656)

## Introduction

TrinityCore is a *MMORPG* Framework based mostly in C++.

It is derived from *MaNGOS*, the *Massive Network Game Object Server*, and is
based on the code of that project with extensive changes over time to optimize,
improve and cleanup the codebase at the same time as improving the in-game
mechanics and functionality.

It is completely open source; community involvement is highly encouraged.

If you wish to contribute ideas or code please visit our site linked below or
make pull requests to our [Github repository](https://github.com/TrinityCore/TrinityCore/pulls).

For further information on the TrinityCore project, please visit our project
website at [TrinityCore.org](https://www.trinitycore.org).

## Requirements


Software requirements are available in the [wiki](https://www.trinitycore.info/display/tc/Requirements) for
Windows, Linux and OS X.


## Install

Detailed installation guides are available in the [wiki](https://www.trinitycore.info/display/tc/Installation+Guide) for
Windows, Linux and OS X.

## Install: cOncienS flavor

```bash
mkdir build
cd build/
cmake ../ -DPREFIX=/home/trinity/server -DCONF_DIR=/home/trinity/server/conf -DLIBSDIR=/home/trinity/server/lib  -DUSE_SFMT=1 -DTOOLS=1 -DSCRIPTS=1 -DSERVERS=1 -DWITH_WARNINGS=1
make
make install
sudo apt-get install libcurl4-openssl-dev p7zip-full vim build-essential autoconf libtool gcc g++ make cmake git-core patch wget links zip unzip unrar openssl libssl-dev mysql-server mysql-client libmysqlclient15-dev libmysql++-dev libreadline6-dev libncurses5-dev zlib1g-dev libbz2-dev libjson-spirit-dev libace-dev libncurses5-dev deluge-console deluge
scp sergio@192.168.1.42:WoW.zip .
cd WoW/
cd Data/
cp ../../gameobject335/patch-g.mpq .
~/server/bin/mapextractor
cp ~/gameobject335/GameObjectDisplayInfo.dbc dbc/
ls dbc/
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
vi authserver.conf
vi worldserver.conf
wget http://www.trinitycore.org/f/files/getdownload/969-tdb-full-updates/
mv index.html   TDB_full_335.53_2014_03_29.7z
7z x TDB_full_335.53_2014_03_29.7z
mysql -u root -p < trinitycore-conciens/sql/create/create_mysql.sql
mysql -u root -p < trinitycore-conciens/sql/base/*
mysql -u root -p < trinitycore-conciens/sql/base/auth_database.sql 
mysql -u root -p auth < trinitycore-conciens/sql/base/auth_database.sql 
mysql -u root -p characters < trinitycore-conciens/sql/base/characters_database.sql 
mysql -u root -p characters < trinitycore-conciens/sql/updates/characters/2014_03_29_00_characters_groups.sql 
mysql -u root -p world < TDB_full_335.53_2014_03_29.sql 
mysql -u root -p characters < trinitycore-conciens/sql/updates/world/2014_0*.sql
cd
git clone https://github.com/mrtazz/restclient-cpp
cd restclient-cpp/
./autogen.sh
./configure
make
sudo make install
cd
git clone https://github.com/miloyip/rapidjson
sudo cp -R rapidjson/include/rapidjson /usr/include/
```

## Reporting issues

Issues can be reported via the [Github issue tracker](https://github.com/TrinityCore/TrinityCore/labels/Branch-3.3.5a).

Please take the time to review existing issues before submitting your own to
prevent duplicates.

In addition, thoroughly read through the [issue tracker guide](https://community.trinitycore.org/topic/37-the-trinitycore-issuetracker-and-you/) to ensure
your report contains the required information. Incorrect or poorly formed
reports are wasteful and are subject to deletion.


## Submitting fixes

C++ fixes are submitted as pull requests via Github. For more information on how to
properly submit a pull request, read the [how-to: maintain a remote fork](https://community.trinitycore.org/topic/9002-howto-maintain-a-remote-fork-for-pull-requests-tortoisegit/).
For SQL only fixes open a ticket or if a bug report exists for the bug post on existing ticket.


## Copyright

License: GPL 2.0

Read file [COPYING](COPYING).


## Authors &amp; Contributors

Read file [AUTHORS](AUTHORS).


## Links

* [Website](https://www.trinitycore.org)
* [Wiki](https://www.trinitycore.info)
* [Forums](https://community.trinitycore.org)
