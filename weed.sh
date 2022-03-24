#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt autoremove

cd ~

wget -c https://golang.org/dl/go1.18.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xvzf go1.18.linux-amd64.tar.gz

mkdir -p ~/go_projects/{bin,src,pkg}

echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee -a /etc/profile
echo 'export GOPATH="$HOME/go_projects"' | sudo tee -a ~/.profile
echo 'export GOBIN="$GOPATH/bin"' | sudo tee -a ~/.profile

source ~/.profile
source /etc/profile

go version
rm -rf seaweedfs
sudo apt-get install -y git build-essential autoconf automake gdb git libffi-dev zlib1g-dev libssl-dev unzip make

git clone https://github.com/chrislusf/seaweedfs.git

cd seaweedfs/weed && make install

cp $GOPATH/bin/weed /usr/local/bin
#
#echo '[Unit]
#Description=SeaweedFS Master
#After=network.target
#
#[Service]
#Type=simple
#User=root
#Group=root
#
#ExecStart=/usr/local/bin/weed master
#WorkingDirectory=/usr/local/bin/
#SyslogIdentifier=seaweedfs-master
#
#[Install]
#WantedBy=multi-user.target' | sudo tee -a /etc/systemd/system/seaweedmaster.service
#
#sudo systemctl daemon-reload
#sudo systemctl start seaweedmaster
#sudo systemctl enable seaweedmaster
#
#
#cd ~
#mkdir /mnt/vol1
#
#echo '[Unit]
#Description=SeaweedFS Volume
#After=network.target
#
#[Service]
#Type=simple
#User=root
#Group=root
#
#ExecStart=/usr/local/bin/weed volume -dir="/mnt/vol1" -max=10 -mserver="127.0.0.1:9333" -port=8081
#WorkingDirectory=/usr/local/bin/
#SyslogIdentifier=seaweedfs-volume
#
#[Install]
#WantedBy=multi-user.target' | sudo tee -a /etc/systemd/system/seaweedvolume1.service
#
#sudo systemctl daemon-reload
#sudo systemctl start seaweedvolume1.service
#sudo systemctl enable seaweedvolume1.service
#
#
#
#
#sudo systemctl status seaweedmaster
#sudo systemctl status seaweedvolume1