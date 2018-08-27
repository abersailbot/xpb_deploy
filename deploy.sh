apt install hostapd gpsd mc git mosh ntp gpsd-clients screen tmux python-pip python-setuptools python-wheel bdist-wheel
cp gpsd /etc/default/gpsd
cp boatd-config.yaml /etc/
cp interfaces /etc/network/
cp *.rules /etc/udev/rules.d
cp iptables.ipv4.nat /etc
cp hostapd.conf /etc/hostapd
#tmux wants the US locale
echo "enable en_US UTF8 locale"
dpkg-reconfigure locales