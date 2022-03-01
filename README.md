# Scripts for Shell

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

## Server Configuration
#### Acme Issue Wildcard Certificate (Using Vultr DNS to Verify)
###### RHEL Based:
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/RHEL_Based/Acme-Wildcard-Cert_Vultr-DNS.sh)
```
#### Install Xray
###### CentOS:
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/RHEL_Based/CentOS/Install-Nginx-Mainline.sh); bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/hijkpw-scripts/main/xray.sh); bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/RHEL_Based/Configure-WARP.sh)
```
#### Configure Port Forwarding
###### Port 80 + 443, CentOS:
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/RHEL_Based/CentOS/Port-Forward-80-443.sh)
```
#### Centos Install EPEL
```
dnf install epel-release epel-next-release
```

## Server Optimization
#### Enable BBR
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/Enable-BBR.sh)
```

## System Configuration
#### Permit Root Login
```
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config; passwd root
```
#### Ubuntu Install GUI
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/Ubuntu/Install-GUI.sh)
```
