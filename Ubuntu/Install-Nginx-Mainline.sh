wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
echo 'deb http://nginx.org/packages/mainline/ubuntu/ codename nginx
deb-src http://nginx.org/packages/mainline/ubuntu/ codename nginx' >> /etc/apt/sources.list
apt update -y
apt install nginx -y
