read -p "Enter your email: " ANSEMAIL
read -p "Enter your domain: " ANSDOMAIN
read -p "Enter your Vultr API key: " ANSAPIKEY
read -p "Enter renew hook: (Leave blank to skip) " ANSRENEWHOOK

if [[ $ANSDOMAIN == "" || $ANSAPIKEY == "" || $ANSEMAIL == '' ]]; then
    echo "Email, Doamin, or Vultr API key cannot be empty. "
    exit 1;
fi

if [[ $(which yum) != '' ]]; then
    yum install socat -y
elif [[ $(which apt) != '' ]]; then
    apt install socat -y
else
    echo "Unsupported system."
    exit 1;
fi

curl https://get.acme.sh | sh -s email=$ANSEMAIL
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt

export VULTR_API_KEY="$ANSAPIKEY"

if [[ $ANSRENEWHOOK != "" ]]; then
    /root/.acme.sh/acme.sh --issue --dns dns_vultr -d $ANSDOMAIN -d *.$ANSDOMAIN -k ec-256 --key-file /root/xray.key --fullchain-file /root/xray.pem --renew-hook "$ANSRENEWHOOK"
else
    /root/.acme.sh/acme.sh --issue --dns dns_vultr -d $ANSDOMAIN -d *.$ANSDOMAIN -k ec-256 --key-file /root/xray.key --fullchain-file /root/xray.pem
fi
