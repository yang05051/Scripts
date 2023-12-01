if [[ $(which qbittorrent-nox == '' && $(which apt) != '' ]]
  then add-apt-repository ppa:qbittorrent-team/qbittorrent-stable; apt update; apt install qbittorrent-nox -y
elif [[ $(which qbittorrent-nox == '' && $(which yum) != '' ]]
  then yum install qbittorrent-nox -y
fi

cat > /etc/systemd/system/qbittorrent.service<<-EOF
[Unit]
Description=qBittorrent-nox service
Documentation=man:qbittorrent-nox(1)
Wants=network-online.target
After=network-online.target nss-lookup.target

[Service]
# if you have systemd < 240 (Ubuntu 18.10 and earlier, for example), you probably want to use Type=simple instead
Type=exec
# change user as needed
User=root
# The -d flag should not be used in this setup
ExecStart=/usr/bin/qbittorrent-nox
# uncomment this for versions of qBittorrent < 4.2.0 to set the maximum number of open files to unlimited
#LimitNOFILE=infinity
# uncomment this to use "Network interface" and/or "Optional IP address to bind to" options
# without this binding will fail and qBittorrent's traffic will go through the default route
# AmbientCapabilities=CAP_NET_RAW

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
