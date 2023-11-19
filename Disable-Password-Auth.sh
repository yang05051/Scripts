if [[ $(grep 'Include \/etc\/ssh\/sshd_config.d\/\*\.conf' /etc/ssh/sshd_config) == '' ]]; then
    echo "Include /etc/ssh/sshd_config.d/*.conf" >> /etc/ssh/sshd_config
else
    if [[ $(grep '^#.*Include \/etc\/ssh\/sshd_config.d\/\*\.conf$' /etc/ssh/sshd_config) != '' ]]; then
        sed -i 's/^#.*Include \/etc\/ssh\/sshd_config.d\/\*\.conf$/Include \/etc\/ssh\/sshd_config.d\/\*\.conf/g' /etc/ssh/sshd_config
    fi
fi

sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config.d/*;

if [[ $(ls /etc/ssh/sshd_config.d | grep 'disable-password-auth\.conf') == '' ]]; then
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config.d/disable-password-auth.conf
else
    if [[ $(grep '^#.*PasswordAuthentication no$' /etc/ssh/sshd_config.d/disable-password-auth.conf) != '' ]]; then
        sed -i 's/^#.*PasswordAuthentication no$/PasswordAuthentication no/g' /etc/ssh/sshd_config.d/disable-password-auth.conf
    fi
fi

systemctl restart ssh
systemctl restart sshd
