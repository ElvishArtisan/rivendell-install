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
yum -y install epel-release
wget http://$REPO_HOSTNAME/CentOS/7com/Paravel-Commercial.repo -P /etc/yum.repos.d/

#
# Install XFCE4
#
yum -y groupinstall "X window system"
yum -y groupinstall xfce
systemctl set-default graphical.target

#
# Install Dependencies
#
yum -y install patch evince  samba qt3-config polymer paravelview mariadb-server ntp emacs twolame libmad
systemctl start mariadb
systemctl enable mariadb

#
# Install Rivendell
#
patch /etc/selinux/config /usr/share/rivendell-install/disable-selinux.patch
cp /usr/share/rivendell-install/asound.conf /etc/
cp /usr/share/rivendell-install/*.repo /etc/yum.repos.d/
cp /usr/share/rivendell-install/RPM-GPG-KEY* /etc/pki/rpm-gpg/
mkdir -p /usr/share/pixmaps/rivendell
cp /usr/share/rivendell-install/rdairplay_skin.png /usr/share/pixmaps/rivendell/
cp /usr/share/rivendell-install/rdpanel_skin.png /usr/share/pixmaps/rivendell/
cp /usr/share/rivendell-install/smb.conf /etc/samba/
mkdir -p /etc/skel/Desktop
cp /usr/share/rivendell-install/skel/rog-1.3.3.pdf /etc/skel/Desktop/Rivendell\ Ops\ Guide.pdf
mkdir -p /etc/skel/rd_xfer
mkdir -p /etc/skel/music_export
mkdir -p /etc/skel/music_import
mkdir -p /etc/skel/traffic_export
mkdir -p /etc/skel/traffic_import
mkdir -p /etc/skel/.qt
cp /usr/share/rivendell-install/qt_plugins_3.3rc /etc/skel/.qt/
cp /usr/share/rivendell-install/qtrc /etc/skel/.qt/
adduser -c Rivendell\ Audio --groups audio rd
patch /etc/gdm/custom.conf /usr/share/rivendell-install/autologin.patch
yum -y remove alsa-firmware alsa-firmware-tools
yum -y install rivendell

#
# Finish Up
#
echo
echo "Installation of Rivendell is complete.  Reboot now."
echo
echo "IMPORTANT: Be sure to see \"First Steps\" after reboot is complete"
echo "           for important information on securing your new Rivendell"
echo "           system!"
echo
