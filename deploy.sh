REPO=/Users/sergio/Documents/Research/trinitycore-conciens 
INSTALL=/Users/sergio/Documents/Research/trinitycore-conciens/build/install 
CLIENT=/Volumes/Manderley/Research/conciens/WoW 
PATCH=/Volumes/Manderley/Research/conciens/gameobject335 
MYSQL=/opt/local/lib/mysql56/bin/mysql
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
find Buildings/ -exec cp { ${INSTALL}/data/vmaps/ \;
cd ${INSTALL}
cd etc/
cd conf/
cp worldserver.conf.dist worldserver.conf
cp authserver.conf.dist authserver.conf
cd /tmp/
wget https://github.com/TrinityCore/TrinityCore/releases/download/TDB335.58/TDB_full_335.58_2015_03_21.7z -O TDB_full_335.58_2015_03_21.7z
7z x -y TDB_full_335.58_2015_03_21.7z
${MYSQL} -u root -ptrinity < ${REPO}/sql/create/create_mysql.sql
${MYSQL} -u root -ptrinity auth < ${REPO}/sql/base/auth_database.sql 
${MYSQL} -u root -ptrinity characters < ${REPO}/sql/base/characters_database.sql 
${MYSQL} -u root -ptrinity world < TDB_full_335.58_2015_03_21.sql
find ${REPO}/sql/updates/world/ -exec sh -c "${MYSQL} -u root -ptrinity world < {}" \;
${MYSQL} -u root -ptrinity characters < ${REPO}/sql/characters_ai_playerbot.sql
${MYSQL} -u root -ptrinity characters < ${REPO}/sql/characters_auctionhousebot.sql
${MYSQL} -u root -ptrinity characters < ${REPO}/sql/characters_ai_playerbot_names.sql
${MYSQL} -u root -ptrinity world < ${PATCH}/gameobjectstrinity.sql

