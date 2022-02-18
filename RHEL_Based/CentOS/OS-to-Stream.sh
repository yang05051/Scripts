yum install centos-release-stream -y
dnf swap centos-{linux,stream}-repos -y
dnf distro-sync -y
cat /etc/centos-release