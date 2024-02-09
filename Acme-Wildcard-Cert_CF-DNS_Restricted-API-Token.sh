echo 'Choose API token type: ' 
echo '(S) API with permissions to edit one single DNS zone'
echo '(M) API with permissions to edit multiple DNS zones'
read -p 'Enter the type ("S" or "M"): ' ANSTOKENTYPE

case $ANSTOKENTYPE in
    'S') 
        read -p 'Enter zone ID: ' ANSZONEID
        if [[ $ANSZONEID == "" ]]; then
            echo "Zone ID should not be empty. "
            exit 1;
        fi
        export CF_Zone_ID="$ANSZONEID"
        ;;
    'M')
        read -p 'Enter account ID: ' ANSACCOUNTID
        if [[ $ANSACCOUNTID == "" ]]; then
            echo "Zone ID should not be empty. "
            exit 1;
        fi
        export CF_Account_ID="$ANSACCOUNTID"
        ;;
    *)
        echo "Please enter the correct type. "
        exit 1;
        ;;
esac

read -p "Enter API token: " ANSAPITOKEN
read -p "Enter your domain: " ANSDOMAIN
read -p "Enter your email for registering ACME account: " ANSEMAIL
read -p "Enter renew hook: (Leave blank to skip) " ANSRENEWHOOK

if [[ $ANSDOMAIN == "" || $ANSAPITOKEN == "" || $ANSEMAIL == "" ]]; then
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

curl https://get.acme.sh | sh -s email="$ANSEMAIL"
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt

export CF_Token="$ANSAPITOKEN"

if [[ $ANSRENEWHOOK != "" ]]; then
    /root/.acme.sh/acme.sh --issue --dns dns_cf -d $ANSDOMAIN -d *.$ANSDOMAIN -k ec-256 --key-file /root/xray.key --fullchain-file /root/xray.pem --renew-hook "$ANSRENEWHOOK"
else
    /root/.acme.sh/acme.sh --issue --dns dns_cf -d $ANSDOMAIN -d *.$ANSDOMAIN -k ec-256 --key-file /root/xray.key --fullchain-file /root/xray.pem
fi
