read -p "Enter your domain: " ANSDOMAIN
read -p "Enter your Vultr API key: " ANSAPIKEY
read -p "Enter your email for registering ACME account: " ANSEMAIL
read -p "Enter renew hook: (Leave blank to skip) " ANSRENEWHOOK
read -p "Enter key file path (Default is /root/xray.key, leave blank to use default): " ANSKEYPATH
read -p "Enter full chain file path (Default is /root/xray.pem, leave blank to use default): " ANSFULLCHAINPATH

if [[ $ANSDOMAIN == "" || $ANSAPIKEY == "" || $ANSEMAIL == '' ]]; then
    echo "Doamin, Vultr API key, or Email for ACME registration cannot be empty. "
    exit 1;
fi

if [[ $ANSKEYPATH != "" ]]; then
    KEYPATH=$ANSKEYPATH
else
    KEYPATH="/root/xray.key"
fi

if [[ $ANSFULLCHAINPATH != "" ]]; then
    FULLCHAINPATH=$ANSFULLCHAINPATH
else    
    FULLCHAINPATH="/root/xray.pem"
fi

if [[ $(which yum) != '' ]]; then
    yum install socat -y
elif [[ $(which apt) != '' ]]; then
    apt install socat -y
else
    echo "Unsupported system."
    exit 1;
fi

curl https://get.acme.sh | sh -s email="$ANSEMAIL"
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt

export VULTR_API_KEY="$ANSAPIKEY"

if [[ $ANSRENEWHOOK != "" ]]; then
    /root/.acme.sh/acme.sh --issue --dns dns_vultr -d $ANSDOMAIN -d *.$ANSDOMAIN -k ec-256 --key-file $KEYPATH --fullchain-file $FULLCHAINPATH --renew-hook "$ANSRENEWHOOK"
else
    /root/.acme.sh/acme.sh --issue --dns dns_vultr -d $ANSDOMAIN -d *.$ANSDOMAIN -k ec-256 --key-file $KEYPATH --fullchain-file $FULLCHAINPATH
fi
