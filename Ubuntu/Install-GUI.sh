apt update -y
apt upgrade -y
apt install slim ubuntu-desktop -y
systemctl set-default graphical.target
apt install xrdp xorg dbus-x11 x11-xserver-utils -y
adduser xrdp ssl-cert
systemctl restart xrdp
