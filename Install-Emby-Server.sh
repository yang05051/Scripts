systemctl stop emby-server

if [[ $(which yum) != '' ]]; then
    yum install jq -y
elif [[ $(which apt) != '' ]]; then
    apt install jq -y
else
    echo "Unsupported system."
    exit 1;
fi

VER=$(curl -s "https://api.github.com/repos/MediaBrowser/Emby.Releases/releases/latest" | jq -r '.tag_name')

wget https://github.com/MediaBrowser/Emby.Releases/releases/download/${VER}/emby-server-deb_${VER}_amd64.deb
dpkg -i emby-server-deb_${VER}_amd64.deb
rm emby-server-deb_${VER}_amd64.deb

systemctl stop emby-server

sed -i 's/User=emby/User=root/g' /lib/systemd/system/emby-server.service
systemctl daemon-reload
systemctl restart emby-server
