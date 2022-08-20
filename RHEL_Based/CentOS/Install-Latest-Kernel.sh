dnf install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
dnf makecache
yum install yum-utils -y
yum-config-manager --enable elrepo-kernel
dnf install -y kernel-ml
