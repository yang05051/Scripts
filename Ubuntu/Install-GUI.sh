apt update -y
apt upgrade -y
apt install ubuntu-desktop -y
apt install xrdp -y
adduser xrdp ssl-cert
systemctl restart xrdp
