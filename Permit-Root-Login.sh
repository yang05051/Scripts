if [[ $(grep 'Include \/etc\/ssh\/sshd_config\.d\/\*\.conf' /etc/ssh/sshd_config) == '' ]]; then
    sed -i '1s/^/Include \/etc\/ssh\/sshd_config\.d\/\*\.conf/g' /etc/ssh/sshd_config
else
    if [[ $(grep '^#.*Include \/etc\/ssh\/sshd_config\.d\/\*\.conf$' /etc/ssh/sshd_config) != '' ]]; then
        sed -i 's/^#.*Include \/etc\/ssh\/sshd_config\.d\/\*\.conf$/Include \/etc\/ssh\/sshd_config.d\/\*\.conf/g' /etc/ssh/sshd_config
    fi
fi

if [[ $(ls /etc/ssh | grep 'sshd_config\.d') == '' ]]; then
    mkdir /etc/ssh/sshd_config.d
fi

sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config;
sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config.d/*;

if [[ $(ls /etc/ssh/sshd_config.d | grep 'permit-root-login\.conf') == '' ]]; then
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config.d/permit-root-login.conf
else
    if [[ $(grep '^#.*PermitRootLogin yes$' /etc/ssh/sshd_config.d/permit-root-login.conf) != '' ]]; then
        sed -i 's/^#.*PermitRootLogin yes$/PermitRootLogin yes/g' /etc/ssh/sshd_config.d/permit-root-login.conf
    fi
fi

systemctl restart ssh
systemctl restart sshd
