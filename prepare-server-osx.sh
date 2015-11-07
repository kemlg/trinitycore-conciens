#!/bin/sh

REPO=`pwd`
INSTALL=${REPO}/build/install
echo "Enter folder of WoW 3.3.5a:"
read CLIENT
echo "Enter folder of gameobject335:"
read PATCH

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
7z x -y TDB_full_335.58_2015_03_21.7z
echo "DROP DATABASE world;" | /opt/local/lib/mysql56/bin/mysql -u root -ptrinity
echo "DROP DATABASE auth;" | /opt/local/lib/mysql56/bin/mysql -u root -ptrinity
echo "DROP DATABASE characters;" | /opt/local/lib/mysql56/bin/mysql -u root -ptrinity
/opt/local/lib/mysql56/bin/mysql -u root -ptrinity < ${REPO}/sql/create/create_mysql.sql
/opt/local/lib/mysql56/bin/mysql -u root -ptrinity world < /tmp/TDB_full_335.58_2015_03_21.sql
/opt/local/lib/mysql56/bin/mysql -u root -ptrinity auth < ${REPO}/sql/base/auth_database.sql 
/opt/local/lib/mysql56/bin/mysql -u root -ptrinity characters < ${REPO}/sql/base/characters_database.sql 
find ${REPO}/sql/updates/world/ -exec sh -c '/opt/local/lib/mysql56/bin/mysql -u root -ptrinity world < {}' \;
/opt/local/lib/mysql56/bin/mysql -u root -ptrinity characters < ${REPO}/sql/characters_ai_playerbot.sql
/opt/local/lib/mysql56/bin/mysql -u root -ptrinity characters < ${REPO}/sql/characters_auctionhousebot.sql
/opt/local/lib/mysql56/bin/mysql -u root -ptrinity characters < ${REPO}/sql/characters_ai_playerbot_names.sql
/opt/local/lib/mysql56/bin/mysql -u root -ptrinity world < ${PATCH}/gameobjectstrinity.sql

sudo port load rabbitmq-server
sudo port load mongodb
sudo port load mysql56-server

cd ${INSTALL}/data
screen -d -m ../bin/authserver
screen ../bin/worldserver

