# Scripts for Shell

## Server Configuration
#### Acme Issue Wildcard Certificate (Using Vultr DNS to Verify)
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/Acme-Wildcard-Cert_Vultr-DNS.sh)
```
#### Install Xray
###### CentOS:
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/RHEL_Based/CentOS/Install-Nginx-Mainline.sh); bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/hijkpw-scripts/main/xray.sh)
```
###### Ubuntu:
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/Configure_UFW.sh); bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/Ubuntu/Install-Nginx-Mainline.sh); bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/hijkpw-scripts/main/xray.sh)
```
#### Install Hysteria
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/HyNetwork/hysteria/master/install_server.sh)
```
#### Install Nginx Mainline
###### CentOS:
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/RHEL_Based/CentOS/Install-Nginx-Mainline.sh)
```
###### Ubuntu:
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/Ubuntu/Install-Nginx-Mainline.sh)
```
#### Install Emby Server
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/Install-Emby-Server.sh)
```
#### Configure Port Forwarding
###### Port 80 + 443:
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/Port-Forward-80-443.sh)
```
#### Configure Cloudflare WARP *(Not recommended)*
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/Configure-WARP.sh)
```

## Server Optimization
#### Enable BBR
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/Enable-BBR.sh)
```
#### Increase UDP Receive Buffer Size
```
echo "net.core.rmem_max=4194304" >> /etc/sysctl.conf; sysctl -p
```

## System Configuration
#### Permit Remote Root Login
```
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
```
#### Disable IPv6
```
echo -e "net.ipv6.conf.all.disable_ipv6=1\nnet.ipv6.conf.default.disable_ipv6=1\nnet.ipv6.conf.lo.disable_ipv6=1" >> /etc/sysctl.conf; sysctl -p
```
#### Disable ICMPing Response
###### Using UFW:
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/Disable-ICMP_UFW.sh)
```
###### Using Sysctl:
```
echo "net.ipv4.icmp_echo_ignore_all=1" >> /etc/sysctl.conf; sysctl -p
```
#### Ubuntu Install GUI
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/Ubuntu/Install-GUI.sh)
```

## System Update
#### Upgrade Kernel
###### CentOS:
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/RHEL_Based/CentOS/Install-Latest-Kernel.sh)
```
###### RHEL 8:
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/RHEL_Based/RHEL_8/Install-Latest-Kernel.sh)
```
#### CentOS Upgrade Kernel + Migrate to Stream Update Channel
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/RHEL_Based/CentOS/OS-to-Stream.sh); bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/RHEL_Based/CentOS/Install-Latest-Kernel.sh)
```
