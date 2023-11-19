if [[ $(grep 'Include \/etc\/ssh\/sshd_config.d\/\*\.conf' /etc/ssh/sshd_config) == '' ]]; then
    echo "Include /etc/ssh/sshd_config.d/*.conf" >> /etc/ssh/sshd_config
else
    if [[$(grep '^#.*Include \/etc\/ssh\/sshd_config.d\/\*\.conf$' /etc/ssh/sshd_config) == '' ]]; then
        sed -i 's/^#.*Include \/etc\/ssh\/sshd_config.d\/\*\.conf$/Include \/etc\/ssh\/sshd_config.d\/\*\.conf/g' /etc/ssh/sshd_config
    fi
fi

sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config.d/*;
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config.d/disable-password-auth.conf
systemctl restart ssh
