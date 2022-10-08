read -p "Enter destination IP/domain: " ANSDEST
read -p "Enter the port that will redirect to destination port 80: " ANSP80
read -p "Enter the port that will redirect to destination port 443: " ANSP443
if [[ ! -z $(which yum) ]]; then
    yum install epel-release epel-next-release -y
    yum install redir -y
elif [[ ! -z $(which apt) ]]; then
    apt install redir -y
else
    echo "Unsupported system."
    exit 1;
fi
redir :$ANSP80 $ANSDEST:80
redir :$ANSP443 $ANSDEST:443
echo "@reboot root redir :$ANSP80 $ANSDEST:80" >> /etc/crontab
echo "@reboot root redir :$ANSP443 $ANSDEST:443" >> /etc/crontab
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/Enable-BBR.sh)
