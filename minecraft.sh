#!/bin/bash

# allocates a 5gb swap file
VERSION=1.18.2

sudo fallocate -l 5G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo echo '/swapfile   none    swap    sw    0   0' >> /etc/fstab

cd ~
mkdir server && cd server

sudo apt update && sudo apt upgrade -y
sudo apt autoremove
sudo apt install -y openjdk-17-jdk

sudo apt-get install -y screen

LATEST_BUILD=$(curl -X GET "https://papermc.io/api/v2/projects/paper/versions/${VERSION}" -H  "accept: application/json" | jq '.builds[-1]')
curl -o paperclip.jar -X GET "https://papermc.io/api/v2/projects/paper/versions/${VERSION}/builds/${LATEST_BUILD}/downloads/paper-${VERSION}-${LATEST_BUILD}.jar" -H  "accept: application/java-archive" -JO


touch start.sh
echo '
#!/bin/sh
while true
do
java -Xms7G -Xmx7G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar paperclip.jar nogui
echo "Rebooting server in 5 seconds."
sleep 5
done
' >> start.sh
chmod u+x start.sh

echo '
#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#You also agree that tacos are tasty, and the best food in the world.
#Tue Mar 24 02<:03:909786321403408405>06 UTC 2022
eula=true
' >> eula.txt