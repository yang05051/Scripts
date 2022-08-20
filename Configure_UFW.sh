if [[ ! -z $(which ufw) ]]; then
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow ssh/tcp
    ufw allow https/tcp
    echo "y" | ufw enable
    systemctl enable ufw
else
    echo "UFW is not installed."
    exit 1
fi
