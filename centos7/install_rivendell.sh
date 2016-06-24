#!/bin/sh

# install_rivendell_centos7.sh
#
# Install Rivendell on a CentOS 7 system
#

#
# Site Defines
#
REPO_HOSTNAME="download.paravelsystems.com"

#
# Configure Repos
#
yum -y install wget epel-release
wget http://$REPO_HOSTNAME/CentOS/7/Paravel-Broadcast.repo -P /etc/yum.repos.d/
wget http://$REPO_HOSTNAME/CentOS/7com/Paravel-Commercial.repo -P /etc/yum.repos.d/
wget http://$REPO_HOSTNAME/CentOS/7/RPM-GPG-KEY-Paravel-Broadcast -P /etc/pki/rpm-gpg/

#
# Install MySQL/MariaDB
#
yum -y install qt3-config polymer paravelview mariadb-server ntp
systemctl start mariadb
systemctl enable mariadb

#
# Install Rivendell
#
yum -y remove alsa-firmware alsa-firmware-tools
yum -y install rivendell

