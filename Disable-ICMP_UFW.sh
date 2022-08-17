if [[ ! -z $(which ufw) ]]; then
    sed -i 's/-A ufw-before-input -p icmp --icmp-type echo-request -j ACCEPT/-A ufw-before-input -p icmp --icmp-type echo-request -j DROP/g' /etc/ufw/before.rules
    sed -i 's/-A ufw6-before-input -p icmpv6 --icmpv6-type echo-request -j ACCEPT/-A ufw6-before-input -p icmpv6 --icmpv6-type echo-request -j DROP/g' /etc/ufw/before6.rules
    ufw reload
else
    echo "UFW is not installed."
    exit 1;
fi
