sudo apt install wget gnupg2 ca-certificates lsb-release ubuntu-keyring software-properties-common -y
wget -O- https://nginx.org/keys/nginx_signing.key | sudo gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg
if [[ -r /etc/os-release ]]; then
    echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" >> /etc/apt/sources.list.d/nginx-ml.list
    echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" >> /etc/apt/preferences.d/99nginx
    echo "y" | ufw enable
    ufw allow http
    ufw allow https
else
    echo "Not running a distribution with /etc/os-release available"
    exit 1;
fi
apt update -y
apt install nginx -y
