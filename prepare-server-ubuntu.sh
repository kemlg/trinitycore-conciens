#!/bin/sh

REPO=`pwd`
INSTALL=/home/trinity/server/
CLIENT=/home/sergio/WoW
PATCH=/home/sergio/gameobject335
# echo "Enter folder of WoW 3.3.5a:"
# read CLIENT
# echo "Enter folder of gameobject335:"
# read PATCH
# 
# cd ${CLIENT}
# cp ${PATCH}/patch-g.mpq Data/
# mapextractor
# cp ${PATCH}/GameObjectDisplayInfo.dbc dbc/
# rm -fR Buildings/
# vmap4extractor
# mkdir ${INSTALL}/data
# cp -r dbc maps ${INSTALL}/data/
# mkdir vmaps
# vmap4assembler Buildings vmaps
# cp -r vmaps ${INSTALL}/data
# find Buildings/ -exec cp {} ${INSTALL}/data/vmaps/ \;
# cd ${INSTALL}
# cd etc/
# cp worldserver.conf.dist worldserver.conf
# cp authserver.conf.dist authserver.conf
cd /tmp/
wget https://github.com/TrinityCore/TrinityCore/releases/download/TDB335.60/TDB_full_335.60_2015_11_07.7z -O TDB_full_335.60_2015_11_07.7z
7z x -y TDB_full_335.60_2015_11_07.7z
echo "DROP DATABASE world;" | mysql -u root -ptrinity
echo "DROP DATABASE auth;" | mysql -u root -ptrinity
echo "DROP DATABASE characters;" | mysql -u root -ptrinity
mysql -u root -ptrinity < ${REPO}/sql/create/create_mysql.sql
mysql -u root -ptrinity world < /tmp/TDB_full_335.58_2015_03_21.sql
mysql -u root -ptrinity auth < ${REPO}/sql/base/auth_database.sql 
mysql -u root -ptrinity characters < ${REPO}/sql/base/characters_database.sql 
find ${REPO}/sql/updates/world/ -exec sh -c 'echo {} ; mysql -u root -ptrinity world < {}' \;
mysql -u root -ptrinity characters < ${REPO}/sql/characters_ai_playerbot.sql
mysql -u root -ptrinity characters < ${REPO}/sql/characters_auctionhousebot.sql
mysql -u root -ptrinity characters < ${REPO}/sql/characters_ai_playerbot_names.sql
mysql -u root -ptrinity world < ${PATCH}/gameobjectstrinity.sql

cd -
screen -d -m authserver
screen worldserver

