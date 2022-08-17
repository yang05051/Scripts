if [[ ! -z $(which ufw) ]]; then
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow ssh
    ufw allow http
    ufw allow https
    systemctl enable ufw
    systemctl start ufw
else
    echo "UFW is not installed."
    exit 1
fi
