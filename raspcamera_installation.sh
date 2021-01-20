#!/bin/bash
 
#Update Password:
passwd pi


#Change hostname:
raspi-config nonint do_hostname raspcamera #sudo raspi-config nonint do_hostname raspcamera
 
#Set TimeZone to Sofia
timedatectl set-timezone Europe/Sofia
 
#Update and Upgrade:
apt update && sudo apt upgrade -y
 
#Install ffmpeg and Motion dependencies:
apt install ffmpeg -y
apt install libmariadb3 -y
apt install libpq5 -y
apt install libmicrohttpd12 -y
 
#Download Motion:
wget https://github.com/Motion-Project/motion/releases/download/release-4.2.2/pi_buster_motion_4.2.2-1_armhf.deb
#Install Motion:
dpkg -i pi_buster_motion_4.2.2-1_armhf.deb
 
#Install dependencies:
apt install python-pip -y
apt install python-pillow -y
apt install python-dev -y
apt install libssl-dev -y
apt install libcurl4-openssl-dev -y
apt install libjpeg-dev -y
apt install libz-de -y
 
#Install MotionEye:
pip install motioneye
 
#Prepare configuration directory:
mkdir -p /etc/motioneye
#Copy configuration to the configuration directory:
cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf
 
#Prepare the media directory:
mkdir -p /var/lib/motioneye
 
#Add init script:
cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service
#Configure to start MotionEye on startup
systemctl daemon-reload
systemctl enable motioneye
systemctl start motioneye
 
#Update to the latest version of MotionEye
pip install motioneye --upgrade
systemctl restart motioneye
 
#Enable Camera:
sudo raspi-config nonint do_camera 0
 
#Add Overclock in /boot/config.txt:
sed -i -e '$a#Custom Overclock:' /boot/config.txt
sed -i -e '$aarm_freq=1000' /boot/config.txt
sed -i -e '$agpu_freq=500' /boot/config.txt
sed -i -e '$asdram_freq=600' /boot/config.txt
sed -i -e '$aover_voltage=6' /boot/config.txt
 
#Clean home directory:
rm pi_buster_motion_4.2.2-1_armhf.deb