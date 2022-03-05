read -p "Enter your destination IP/domain: " ANSDEST
if [[ ! -z $(which yum) ]]; then
    yum install epel-release epel-next-release -y
    yum install redir -y
elif [[ ! -z $(which apt) ]]; then
    apt install redir -y
else
    echo "Unsupported system."
    exit 1;
fi
redir :80 $ANSDEST:80
redir :443 $ANSDEST:443
echo "@reboot root redir :80 $ANSDEST:80" >> /etc/crontab
echo "@reboot root redir :443 $ANSDEST:443" >> /etc/crontab
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/Enable-BBR.sh)
