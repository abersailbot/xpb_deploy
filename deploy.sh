#!/bin/bash

#exit if any command fails
set -e 

if [ `whoami` != "root" ] ; then
    echo "Rerun as root"
    exit 1
fi

apt -y update
apt -y install hostapd gpsd mc git mosh ntp gpsd-clients screen tmux isc-dhcp-server vim-nox lsof tcpdump libyaml-dev python3-pip
apt -y upgrade

git clone --recursive https://github.com/abersailbot/xpb
cd /home/pi/xpb/xpb_deploy

cp gpsd /etc/default/gpsd
cp boatd-config.yaml /etc/
cp interfaces /etc/network/
cp *.rules /etc/udev/rules.d
cp iptables.ipv4.nat /etc
cp hostapd.conf /etc/hostapd
cp hostapd /etc/default/hostapd
cp isc-dhcp-server /etc/default/isc-dhcp-server
cp dhcpd.conf /etc/dhcp/dhcpd.conf
cp cmdline.txt /boot/cmdline.txt
cp motd /etc/motd
cp ntp.conf /etc/ntp.conf

mkdir /var/log/boatd

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf


#tmux wants the US locale??? Seems to work without it, commenting out for now
#echo "enable en_US UTF8 locale"
#dpkg-reconfigure locales

#enable SSHD
systemctl enable ssh

#enable hostapd
systemctl unmask hostapd
systemctl enable hostapd

#install platformio
wget https://raw.githubusercontent.com/platformio/platformio/develop/scripts/get-platformio.py
python get-platformio.py
#put platformio in the path
echo "export PATH=$PATH:/home/pi/.local/bin/" >> ~/.bashrc

export PATH=$PATH:/home/pi/.local/bin/

#install python3 gpsd stuff
pip3 install gps
#install boatd
pip3 install python-boatdclient

cd /home/pi/xpb
cd boatd
python3 setup.py install
cd /home/pi/xpb/xpb_deploy
#change boatd to run in python3
sudo sed -i 's@^#!/usr/bin/python$@#!/usr/bin/python3@' /usr/local/bin/boatd

#install boatd service
cp boatd.service /etc/systemd/system/boatd.service
systemctl daemon-reload
systemctl enable boatd

#symlink driver
ln -s /home/pi/xpb/xpb-boatd-driver/xpb_boatd_driver.py /usr/local/lib/python3.7/dist-packages

#set the password to something more secure
usermod -p '$6$2VfUJBiCiUNV/RkL$gz2TUtullYN2svx6jb39UESyOholUdE/EehNoqCKagEpzfJMS1wK9hOr1BkQpSMXbbu4Pmr8Pli6zanQ.g10Q0' pi

#install SSH keys
mkdir /home/pi/.ssh
chmod 700 /home/pi/.ssh
cp /home/pi/xpb/xpb_deploy/authorized_keys /home/pi/.ssh/authorized_keys
chmod 600  /home/pi/.ssh/authorized_keys

#set the timezone
rm /etc/localtime
ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime

