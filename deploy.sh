apt update
apt install hostapd gpsd mc git mosh ntp gpsd-clients screen tmux python-pip python-setuptools python-wheel isc-dhcp-server vim-nox lsof tcpdump libyaml-dev
apt upgrade

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

mkdir /var/log/boatd

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf


#tmux wants the US locale
echo "enable en_US UTF8 locale"
dpkg-reconfigure locales

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


sudo pip install python-boatdclient

cd /home/pi/xpb
cd boatd
sudo python setup.py install
cd ..
cd xpb-boatd-driver
sudo ln -s xpb_boatd_driver.py /usr/local/lib/python2.7/dist-packages

#set the password to something more secure
sudo usermod -p '$6$2VfUJBiCiUNV/RkL$gz2TUtullYN2svx6jb39UESyOholUdE/EehNoqCKagEpzfJMS1wK9hOr1BkQpSMXbbu4Pmr8Pli6zanQ.g10Q0' pi
