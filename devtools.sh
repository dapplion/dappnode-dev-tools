

DAPPNODE_SRC=/usr/src/dappnode/DNCORE
cd $DAPPNODE_SRC

#############
# PORTAINER #
#############

PORTAINER=${DAPPNODE_SRC}/docker-compose-portainer.yml

cat > $PORTAINER <<EOF
version: '2'

services:
  portainer:
    image: portainer/portainer
    restart: always
    ports:
      - "9000:9000"
    command: -H unix:///var/run/docker.sock
    environment:
      - ADMIN_USERNAME=dappnode
      - ADMIN_PASS=dappnode
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data

volumes:
  portainer_data:
EOF

docker-compose -f $PORTAINER up -d

############
# WATCHDOG #
############

WATCHDOG=${DAPPNODE_SRC}/docker-compose-watchdog.yml

cat > $WATCHDOG <<EOF
version: "3"
services:
  watchdog:
    image: v2tec/watchtower
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command: --interval 30
EOF

docker-compose -f $WATCHDOG up -d

##############
# DC SCRIPTS #
##############

UP=/usr/bin/up
cat > $UP <<EOF
DNP=\$1
docker-compose -f ${DAPPNODE_SRC}/docker-compose-\${DNP}.yml up -d
EOF
chmod +x $UP

INTO=/usr/bin/into
cat > $INTO <<EOF
DNP=\$1
docker exec -it DAppNodeCore-\${DNP}.dnp.dappnode.eth sh
EOF
chmod +x $INTO

RESTORE=/usr/bin/restore
cat > $RESTORE <<EOF
sudo rm  /usr/src/dappnode/docker-compose*.yml 
wget -O - https://github.com/dappnode/DAppNode/releases/download/v0.1.1/dappnode_install.sh | sudo bash
EOF
chmod +x $RESTORE

#################
# MODIFY bashrc #
#################

echo " " >> ~/.bashrc
echo "alias admin='admin'" >> ~/.bashrc
echo "alias bind='bind'" >> ~/.bashrc
echo "alias dappmanager='dappmanager'" >> ~/.bashrc
echo "alias ethchain='ethchain'" >> ~/.bashrc
echo "alias ethforward='ethforward'" >> ~/.bashrc
echo "alias ipfs='ipfs'" >> ~/.bashrc
echo "alias vpn='vpn'" >> ~/.bashrc
echo "alias wamp='wamp'" >> ~/.bashrc

echo " " >> ~/.bashrc
echo "cd $DAPPNODE_SRC" >> ~/.bashrc



