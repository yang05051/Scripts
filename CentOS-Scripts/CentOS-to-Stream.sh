yum install centos-release-stream -y
dnf swap centos-{linux,stream}-repos
dnf distro-sync -y
cat /etc/centos-release