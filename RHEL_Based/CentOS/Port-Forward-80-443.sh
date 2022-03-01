read -p "Enter your destination IP/domain: " ANSDEST
dnf install epel-release -y
dnf install epel-next-release -y
yum install redir -y
redir :80 $ANSDEST:80
redir :443 $ANSDEST:443
echo "@reboot root redir :80 $ANSDEST:80" >> /etc/crontab
echo "@reboot root redir :443 $ANSDEST:443" >> /etc/crontab
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/Enable-BBR.sh)
