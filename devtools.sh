#!/bin/bash

DAPPNODE_SRC=/usr/src/dappnode/DNCORE
cd $DAPPNODE_SRC

##############
# DC SCRIPTS #
##############

UP=/usr/bin/up
cat > $UP <<EOF
#!/bin/bash
DNP=\$1
docker-compose -f ${DAPPNODE_SRC}/docker-compose-\${DNP}.yml up -d
EOF
chmod +x $UP


INTO=/usr/bin/into
cat > $INTO <<EOF
#!/bin/bash
DNP=\$1
docker exec -it DAppNodeCore-\${DNP}.dnp.dappnode.eth sh
EOF
chmod +x $INTO


RESTORE=/usr/bin/restore
cat > $RESTORE <<EOF
#!/bin/bash
sudo rm  /usr/src/dappnode/docker-compose*.yml 
wget -O - https://github.com/dappnode/DAppNode/releases/download/v0.1.1/dappnode_install.sh | sudo bash
EOF
chmod +x $RESTORE


TO_VER=/usr/bin/toVer
cat > $TO_VER <<EOF
#!/bin/bash
REPO=$1 # lowercase, i.e. dappmanager
BRANCH=${2:-dev}
REPO_DIR="DNP_$(echo $REPO | awk '{print toupper($0)}')"
sudo rm -rf $REPO_DIR
sudo git clone https://github.com/dappnode/${REPO_DIR}.git -b $BRANCH
cd $REPO_DIR
docker-compose -f docker-compose-${REPO}.yml build
up $REPO
EOF
chmod +x $TO_VER


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



