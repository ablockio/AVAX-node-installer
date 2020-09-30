#!/bin/bash

#######################################
# Bash script to install dependencies in UBUNTU
# for https://www.avalabs.org/ Nodes
# ######################################

_VERSION=1.0.1

echo '    /\ \    / /\    \ \ / / |  ____\ \    / /  ____|  __ \|  ____|/ ____|__   __|'
echo '   /  \ \  / /  \    \ V /  | |__   \ \  / /| |__  | |__) | |__  | (___    | |   '
echo '  / /\ \ \/ / /\ \    > <   |  __|   \ \/ / |  __| |  _  /|  __|  \___ \   | |   '
echo ' / ____ \  / ____ \  / . \  | |____   \  /  | |____| | \ \| |____ ____) |  | |   '
echo '/_/    \_\/_/    \_\/_/ \_\ |______|   \/   |______|_|  \_\'$_VERSION'_|_____/   |_|   '
echo 'If you want to help us, contact us on contact@ablock.io'


echo '### Checking if systemd is supported...'
if systemctl show-environment &> /dev/null ; then
SYSTEMD_SUPPORTED=1
echo 'systemd is available, using it'
else
echo 'systemd is not available on this machine, will use supervisord instead'
fi

echo '### Updating packages...'
sudo apt-get update -y

echo '### Installing Go...'
wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.13.linux-amd64.tar.gz
echo "export PATH=/usr/local/go/bin:$PATH" >> $HOME/.profile
source $HOME/.profile
go version

echo '### Installing nodejs...'
sudo apt-get update -y
# sudo apt upgrade
sudo apt-get -y install curl dirmngr apt-transport-https lsb-release ca-certificates
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get -y install gcc g++ make
sudo apt-get -y install nodejs
sudo apt-get -y install npm


echo '### Updating packages...'
sudo apt-get update -y

echo '### Installing nodejs...'
sudo apt-get -y install nodejs
sudo apt-get -y install npm

echo '### Setting GOPATH'
go env -w GOPATH=$HOME/go
echo "export GOPATH=$HOME/go" >> ~/.bash_profile
source ~/.bash_profile
export GOPATH=$HOME/go
sudo rm -rf $GOPATH

echo '### Cloning gecko directory...'
cd $HOME
go get -v -d github.com/ava-labs/avalanchego/...

cd $GOPATH/src/github.com/ava-labs/avalanchego
./scripts/build.sh

echo '### Creating AVA node service...'
if [ -n "$SYSTEMD_SUPPORTED" ]; then
sudo USER=$USER bash -c 'cat <<EOF > /etc/systemd/system/avaxnode.service
[Unit]
Description=AVAX Everest Node service
After=network.target

[Service]
User=$USER
Group=$USER

ARG2=-api-admin-enabled=true -api-health-enabled=true -api-info-enabled=true -api-ipcs-enabled=true  -api-metrics-enabled=true -api-keystore-enabled=true -api-metrics-enabled=true --http-host=ec2-3-133-220-103.us-east-2.compute.amazonaws.com --http-port=9650

WorkingDirectory='$GOPATH'/src/github.com/ava-labs/avalanchego
ExecStart='$GOPATH'/src/github.com/ava-labs/avalanchego/build/avalanchego


Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=5

[Install]
WantedBy=multi-user.target
EOF'
else
sudo bash -c 'cat <<EOF > /etc/supervisor/conf.d/avaxnode.conf
[program:avaxnode]
directory='$GOPATH'/src/github.com/ava-labs/avalanchego
command='$GOPATH'/src/github.com/ava-labs/avalanchego/build/avalanchego
user=$SUDO_USER
environment=HOME="/home/$SUDO_USER",USER="$SUDO_USER"
autostart=true
autorestart=true
startsecs=10
startretries=20
stdout_logfile=/var/log/avaxnode-stdout.log
stdout_logfile_maxbytes=10MB
stdout_logfile_backups=1
stderr_logfile=/var/log/avaxnode-stderr.log
stderr_logfile_maxbytes=10MB
stderr_logfile_backups=1
EOF'
fi

echo '### Launching AVAX node...'
if [ -n "$SYSTEMD_SUPPORTED" ]; then
sudo systemctl enable avaxnode
sudo systemctl start avaxnode
echo 'Type the following command to monitor the AVA node service:'
echo '    sudo systemctl status avaxnode'
else
sudo service supervisor start
sudo supervisorctl start avaxnode
echo 'Type the following command to monitor the AVA node service:'
echo '    sudo supervisorctl status avaxnode'
fi
