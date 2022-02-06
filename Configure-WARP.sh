yum install epel-release -y
yum install wireguard-tools -y
read -p "Enter your IP: " ANSIP
read -p "Enter your private key of WARP: " ANSPRVKEY
read -p "Enter your public key of WARP: " ANSPUBKEY
modprobe wireguard
lsmod | grep wireguard
cat > /etc/wireguard/wgcf.conf<<-EOF
[Interface]
PrivateKey = $ANSPRVKEY
Address = 172.16.0.2/32
Address = fd01:5ca1:ab1e:86e2:7865:61f7:b8f8:765/128
DNS = 1.1.1.1
MTU = 1280
PostUp = ip rule add from $ANSIP lookup main
PostDown = ip rule delete from $ANSIP lookup main
[Peer]
PublicKey = $ANSPUBKEY
AllowedIPs = 0.0.0.0/0
AllowedIPs = ::/0
Endpoint = 162.159.192.1:2408 
EOF
systemctl enable wg-quick@wgcf.service
systemctl start wg-quick@wgcf
