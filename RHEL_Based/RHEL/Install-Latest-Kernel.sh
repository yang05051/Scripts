yum install yum-utils -y
dnf install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
dnf makecache
sed -i 's/$releasever/8/g' /etc/yum.repos.d/epel*.repo
yum-config-manager --enable elrepo-kernel
dnf install -y kernel-ml
