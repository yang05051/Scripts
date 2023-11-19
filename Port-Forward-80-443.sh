read -p "Enter destination IP/domain: " ANSDEST

if [[ $ANSDEST == "" ]]; then
    echo "No destination IP/domain entered."
    exit 1;
fi

read -p "Enter the port that will redirect to destination port 80: (Leave it blank if you do not want to) " ANSP80
read -p "Enter the port that will redirect to destination port 443: (Leave it blank if you do not want to) " ANSP443

if [[ $ANSP80 == "" && $ANSP443 == "" ]]; then
    echo "No port entered."
    exit 1;
fi

if [[ $(which yum) != '' ]]; then
    yum install epel-release epel-next-release -y
    yum install redir -y
elif [[ $(which apt) != '' ]]; then
    apt install redir -y
else
    echo "Unsupported system."
    exit 1;
fi

if [[ $ANSP80 != "" ]]; then
    redir :$ANSP80 $ANSDEST:80
    echo "@reboot root redir :$ANSP80 $ANSDEST:80" >> /etc/crontab
fi
if [[ $ANSP443 != "" ]]; then
    redir :$ANSP443 $ANSDEST:443
    echo "@reboot root redir :$ANSP443 $ANSDEST:443" >> /etc/crontab
fi

bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/Enable-BBR.sh)
