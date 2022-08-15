ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw allow https
systemctl enable ufw
systemctl start ufw
