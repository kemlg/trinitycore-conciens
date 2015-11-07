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
find Buildings/ -exec cp {} ${INSTALL}/data/vmaps/ \;
cd ${INSTALL}
cd etc/
cp worldserver.conf.dist worldserver.conf
cp authserver.conf.dist authserver.conf
cp ahbot.conf.dist.in ahbot.conf
cp aiplayerbot.conf.dist.in aiplayerbot.conf
cd /tmp/
rm -f TDB_full_335.59_2015_07_14.7z
wget https://github.com/TrinityCore/TrinityCore/releases/download/TDB335.59/TDB_full_335.59_2015_07_14.7z
7z x -y TDB_full_335.59_2015_07_14.7z
${MYSQL} -u root -ptrinity -e "DROP DATABASE auth"
${MYSQL} -u root -ptrinity -e "DROP DATABASE world"
${MYSQL} -u root -ptrinity -e "DROP DATABASE characters"
${MYSQL} -u root -ptrinity < ${REPO}/sql/create/create_mysql.sql
${MYSQL} -u root -ptrinity auth < ${REPO}/sql/base/auth_database.sql 
${MYSQL} -u root -ptrinity characters < ${REPO}/sql/base/characters_database.sql 
${MYSQL} -u root -ptrinity world < TDB_full_world_335.59_2015_07_14.sql
find ${REPO}/sql/updates/world/ -exec sh -c "echo {} ; ${MYSQL} -u root -ptrinity world < {}" \;
${MYSQL} -u root -ptrinity characters < ${REPO}/sql/characters_ai_playerbot.sql
${MYSQL} -u root -ptrinity characters < ${REPO}/sql/characters_auctionhousebot.sql
${MYSQL} -u root -ptrinity characters < ${REPO}/sql/characters_ai_playerbot_names.sql
${MYSQL} -u root -ptrinity world < ${PATCH}/gameobjectstrinity.sql

