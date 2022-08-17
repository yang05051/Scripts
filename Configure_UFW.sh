if [[ ! -z $(which ufw) ]]; then
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow ssh
    ufw allow http
    ufw allow https
    ufw enable
    systemctl enable ufw
else
    echo "UFW is not installed."
    exit 1
fi
