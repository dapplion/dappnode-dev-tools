#!/bin/bash

DAPPNODE_SRC=/usr/src/dappnode/DNCORE
cd $DAPPNODE_SRC

##############
# DC SCRIPTS #
##############

UP=/usr/bin/up
rm -f $UP
cat > $UP <<EOF
#!/bin/bash
DNP=\$1
docker-compose -f ${DAPPNODE_SRC}/docker-compose-\${DNP}.yml up -d
EOF
chmod +x $UP
echo "Added command 'up' to $UP"


LOG=/usr/bin/log
rm -f $LOG
cat > $LOG <<EOF
#!/bin/bash
DNP=\$1
docker logs DAppNodeCore-\${DNP}.dnp.dappnode.eth -f
EOF
chmod +x $LOG
echo "Added command 'log' to $LOG"


INTO=/usr/bin/into
rm -f $INTO
cat > $INTO <<EOF
#!/bin/bash
DNP=\$1
docker exec -it DAppNodeCore-\${DNP}.dnp.dappnode.eth sh
EOF
chmod +x $INTO
echo "Added command 'into' to $INTO"


RESTORE=/usr/bin/restore
rm -f $RESTORE
cat > $RESTORE <<EOF
#!/bin/bash
sudo rm  /usr/src/dappnode/docker-compose*.yml 
wget -O - https://github.com/dappnode/DAppNode/releases/download/v0.1.1/dappnode_install.sh | sudo bash
EOF
chmod +x $RESTORE
echo "Added command 'restore' to $RESTORE"


TO_VER=/usr/bin/toVer
rm -f $TO_VER
cat > $TO_VER <<EOF
#!/bin/bash
REPO=\$1 # lowercase, i.e. dappmanager
REPO_TAG="DNP_\$(echo \$REPO | awk '{print toupper(\$0)}')"
BRANCH=\${2:-dev}
REPO_DIR="${DAPPNODE_SRC}/\${REPO_TAG}"
sudo rm -rf \$REPO_DIR
mkdir -p \$REPO_DIR
sudo git clone https://github.com/dappnode/\${REPO_TAG}.git -b \$BRANCH \$REPO_DIR
cd \$REPO_DIR
docker-compose -f \${REPO_DIR}/docker-compose*.yml build
up \$REPO
log \$REPO
EOF
chmod +x $TO_VER
echo "Added command 'toVer' to $TO_VER"


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



