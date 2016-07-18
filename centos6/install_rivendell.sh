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
wget http://$REPO_HOSTNAME/CentOS/6com/Paravel-Commercial.repo -P /etc/yum.repos.d/

#
# Install Dependencies
#
yum -y install evince telnet lwmon nc samba qt3-config polymer paravelview mysql-server emacs twolame libmad ssvnc
service mysqld start
chkconfig mysqld on

#
# Ensure that user 'rd' exists
#
getent passwd rd > /dev/null
if [ $? -ne 0 ]; then
    adduser -c Rivendell\ Audio --groups audio rd
fi

#
# Install Rivendell
#
patch /etc/selinux/config /usr/share/rivendell-install/disable-selinux.patch
iptables -F
iptables -F -t nat
service iptables save
rm -f /etc/asound.conf
cp /usr/share/rivendell-install/asound.conf /etc/
cp /usr/share/rivendell-install/*.repo /etc/yum.repos.d/
cp /usr/share/rivendell-install/RPM-GPG-KEY* /etc/pki/rpm-gpg/
mkdir -p /usr/share/pixmaps/rivendell
cp /usr/share/rivendell-install/rdairplay_skin.png /usr/share/pixmaps/rivendell/
cp /usr/share/rivendell-install/rdpanel_skin.png /usr/share/pixmaps/rivendell/
cp /usr/share/rivendell-install/smb.conf /etc/samba/
cp /usr/share/rivendell-install/no_screen_blank.conf /etc/X11/xorg.conf.d/
mkdir -p /etc/skel/Desktop
cp /usr/share/rivendell-install/skel/rog-1.3.3.pdf /etc/skel/Desktop/Rivendell\ Ops\ Guide.pdf
cp /usr/share/rivendell-install/skel/paravel_support.pdf /etc/skel/Desktop/First\ Steps.pdf
mkdir -p /etc/skel/.qt
cp /usr/share/rivendell-install/qt_plugins_3.3rc /etc/skel/.qt/
cp /usr/share/rivendell-install/qtrc /etc/skel/.qt/
mkdir -p /home/rd/rd_xfer
mkdir -p /home/rd/music_export
mkdir -p /home/rd/music_import
mkdir -p /home/rd/traffic_export
mkdir -p /home/rd/traffic_import
mkdir -p /home/rd/Desktop
cp /usr/share/rivendell-install/skel/rog-1.3.3.pdf /home/rd/Desktop/Rivendell\ Ops\ Guide.pdf
cp /usr/share/rivendell-install/skel/paravel_support.pdf /home/rd/Desktop/First\ Steps.pdf
mkdir -p /home/rd/.qt
cp /usr/share/rivendell-install/qt_plugins_3.3rc /home/rd/.qt/
cp /usr/share/rivendell-install/qtrc /home/rd/.qt/
chown -R rd:rd /home/rd
patch /etc/gdm/custom.conf /usr/share/rivendell-install/autologin.patch
yum -y install rivendell

#
# Finish Up
#
echo
echo "Installation of Rivendell is complete.  Reboot now."
echo
echo "IMPORTANT: Be sure to see the FINAL DETAILS section in the instructions"
echo "           to ensure that your new Rivendell system is properly secured."
echo
