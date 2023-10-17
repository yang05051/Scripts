ANSSYMLINK=$(readlink /etc/resolv.conf)

if [[ANSSYMLINK != '/run/resolvconf/resolv.conf`]]; then
    if [[ANSSYMLINK == '']]; then
        cp /etc/resolv.conf /etc/resolv.conf.bak
    else
        ln -s ANSSYMLINK /etc/resolv.conf.bak
    fi
fi