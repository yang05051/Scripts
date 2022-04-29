wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
if [[ -r /etc/os-release ]]; then
    echo "deb http://nginx.org/packages/mainline/ubuntu/ $(lsb_release -cs) nginx"  >> /etc/apt/sources.list.d/nginx-ml.list
    echo "deb-src http://nginx.org/packages/mainline/ubuntu/ $(lsb_release -cs) nginx" >> /etc/apt/sources.list.d/nginx-ml.list
    ufw disable
else
    echo "Not running a distribution with /etc/os-release available"
    exit 1;
fi
apt update -y
apt install nginx -y
