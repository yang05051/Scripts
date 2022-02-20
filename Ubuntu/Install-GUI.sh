apt update -y; apt upgrade -y
apt install slim -y
apt install tasksel -y
tasksel install ubuntu-desktop -y
systemctl set-default graphical.target