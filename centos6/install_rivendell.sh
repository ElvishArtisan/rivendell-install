#!/bin/sh

# install_rivendell.sh
#
# Install Rivendell on a CentOS 6 system
#

#
# Site Defines
#
REPO_HOSTNAME="download.paravelsystems.com"

#
# Configure Repos
#
#yum -y install epel-release
wget http://$REPO_HOSTNAME/CentOS/6com/Paravel-Commercial.repo -P /etc/yum.repos.d/

#
# Install Dependencies
#
yum -y install evince telnet lwmon nc samba qt3-config polymer paravelview mysql-server emacs twolame libmad
service mysqld start
chkconfig mysqld on

#
# Install Rivendell
#
patch /etc/selinux/config /usr/share/rivendell-install/disable-selinux.patch
iptables -F
iptables -F -t nat
service iptables save
cp -n /usr/share/rivendell-install/asound.conf /etc/
cp -n /usr/share/rivendell-install/*.repo /etc/yum.repos.d/
cp -n /usr/share/rivendell-install/RPM-GPG-KEY* /etc/pki/rpm-gpg/
mkdir -p /usr/share/pixmaps/rivendell
cp -n /usr/share/rivendell-install/rdairplay_skin.png /usr/share/pixmaps/rivendell/
cp -n /usr/share/rivendell-install/rdpanel_skin.png /usr/share/pixmaps/rivendell/
cp -n /usr/share/rivendell-install/smb.conf /etc/samba/
mkdir -p /etc/skel/Desktop
cp -n /usr/share/rivendell-install/skel/rog-1.3.3.pdf /etc/skel/Desktop/Rivendell\ Ops\ Guide.pdf
mkdir -p /etc/skel/rd_xfer
mkdir -p /etc/skel/music_export
mkdir -p /etc/skel/music_import
mkdir -p /etc/skel/traffic_export
mkdir -p /etc/skel/traffic_import
mkdir -p /etc/skel/.qt
cp /usr/share/rivendell-install/qt_plugins_3.3rc /etc/skel/.qt/
cp /usr/share/rivendell-install/qtrc /etc/skel/.qt/
patch /etc/gdm/custom.conf /usr/share/rivendell-install/autologin.patch
yum -y install rivendell

#
# Finish Up
#
echo
echo "Installation of Rivendell is complete.  Reboot now."
echo
echo "IMPORTANT: Be sure to see the FINISHING UP section in the instructions"
echo "           to ensure that your new Rivendell system is properly secured."
echo
