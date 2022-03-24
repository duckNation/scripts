#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt autoremove

sudo apt install -y redis-server

sudo sed -i '236s/.*/supervised systemd/' /etc/redis/redis.conf
sudo systemctl restart redis