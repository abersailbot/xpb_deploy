apt install hostapd gpsd mc git mosh ntp gpsd-clients screen tmux python-pip python-setuptools python-wheel bdist-wheel isc-dhcp-server vim-nox lsof tcpdump
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