# Scripts for Shell

## System Update
#### CentOS Upgrade Kernel
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/RHEL_Based/CentOS/Install-Latest-Kernel.sh)
```
#### CentOS Upgrade Kernel + Migrate to Stream Update Channel
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/RHEL_Based/CentOS/OS-to-Stream.sh); bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/RHEL_Based/CentOS/Install-Latest-Kernel.sh)
```

## Server Configuration
#### Acme Issue Wildcard Certificate (Using Vultr DNS to Verify)
##### RHEL Based
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/RHEL_Based/Acme-Wildcard-Cert_Vultr-DNS.sh)
```
#### Install Xray
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/RHEL_Based/CentOS/Install-Nginx-Mainline.sh); bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/hijkpw-scripts/main/xray.sh); bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/RHEL_Based/Configure-WARP.sh)
```

## Server Optimization
#### Enable BBR
```
bash <(curl -H 'Cache-Control: no-cache' -sL https://raw.githubusercontent.com/yang05051/Scripts/main/Enable-BBR.sh)
```
