

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

UP=/usr/bin/up.sh
cat > $UP <<EOF
DNP=$1
docker-compose -f /usr/src/dappnode/DNCORE/${DNP} up -d
EOF
chmod +x $UP

RM=/usr/bin/rm.sh
cat > $RM <<EOF
DNP=$1
docker rm -f DAppNodeCore-${DNP}.dnp.dappnode.eth -t 0
EOF
chmod +x $UP

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



