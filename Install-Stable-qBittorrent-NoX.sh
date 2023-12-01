if [[ $(which qbittorrent-nox) == '' ]]; then
  if [[ $(which apt) != '' ]]
    then add-apt-repository ppa:qbittorrent-team/qbittorrent-stable; apt update; apt install qbittorrent-nox -y
  elif [[ $(which yum) != '' ]]
    then yum install qbittorrent-nox -y
  else
    echo "Unsupported system."
    exit 1;
  fi
fi

echo '[Unit]
Description=qBittorrent-nox service
Documentation=man:qbittorrent-nox(1)
Wants=network-online.target
After=network-online.target nss-lookup.target

[Service]
Type=exec
User=root
ExecStart=/usr/bin/qbittorrent-nox --daemon --webui-port=8097

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/qbittorrent.service

systemctl daemon-reload
