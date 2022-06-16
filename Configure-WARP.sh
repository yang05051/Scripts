read -p "Enter your IP: " ANSIP
read -p "Enter your private key of WARP: " ANSPRVKEY
read -p "Enter your public key of WARP: " ANSPUBKEY
if [[ ! -z $(which yum) ]]; then
    yum install epel-release -y
    yum install wireguard-tools -y
elif [[ ! -z $(which apt) ]]; then
    apt install wireguard -y
    apt install openresolv -y
else
    echo "Unsupported system."
    exit 1;
fi
modprobe wireguard
lsmod | grep wireguard
cat > /etc/wireguard/wgcf.conf<<-EOF
[Interface]
PrivateKey = $ANSPRVKEY
Address = 172.16.0.2/32
Address = fd01:5ca1:ab1e:86e2:7865:61f7:b8f8:765/128
DNS = 1.1.1.1
MTU = 1420
PostUp = ip rule add from $ANSIP lookup main
PostDown = ip rule delete from $ANSIP lookup main
[Peer]
PublicKey = $ANSPUBKEY
AllowedIPs = 0.0.0.0/0
AllowedIPs = ::/0
Endpoint = engage.cloudflareclient.com:2408 
EOF
systemctl enable wg-quick@wgcf.service
systemctl start wg-quick@wgcf
