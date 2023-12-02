if [[ $(which qbittorrent-nox) == '' ]]; then
  if [[ $(which apt) != '' ]]
    then add-apt-repository ppa:poplite/qbittorrent-enhanced; apt update; apt install qbittorrent-enhanced-nox -y
  else
    echo "Unsupported system."
    exit 1;
  fi
fi

echo "[Unit]
Description=qBittorrent Enhanced Edition Service
Documentation=man:qbittorrent-nox(1)
Wants=network-online.target
After=network-online.target nss-lookup.target

[Service]
Type=exec
User=root
ExecStart=/usr/bin/qbittorrent-nox

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/qbittorrent.service

systemctl daemon-reload
