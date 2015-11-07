INSTALL=/Users/sergio/Documents/Research/trinitycore-conciens/build/install 
cd ${INSTALL}/data
screen -d -m ../bin/authserver
screen ../bin/worldserver
