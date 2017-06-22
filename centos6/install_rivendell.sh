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
# Get Target Mode
#
if test $1 ; then
    case "$1" in
	--client)
	    MODE="client"
	    ;;

	--server)
	    MODE="server"
	    ;;

	--standalone)
	    MODE="standalone"
	    ;;

	*)
	    echo "USAGE: ./install_rivendell.sh --client|--server|--standalone"
	    exit 256
            ;;
    esac
else
    MODE="standalone"
fi

#
# Get Server IP Address
#
if test $MODE = "client" ; then
    echo -n "Enter IP address of Rivendell server: "
    read IP_ADDR
fi

#
# Configure Repos
#
wget http://$REPO_HOSTNAME/CentOS/6com/Paravel-Commercial.repo -P /etc/yum.repos.d/

#
# Install Dependencies
#
yum -y install evince telnet lwmon nc samba qt3-config polymer paravelview emacs twolame libmad ssvnc

if test $MODE = "server" ; then
    #
    # Install MySQL
    #
    yum -y install mysql-server
    service mysqld start
    chkconfig mysqld on

    #
    # Enable DB Access for all remote hosts
    #
    echo "CREATE USER 'rduser'@'%' IDENTIFIED BY 'letmein';" | mysql -u root
    echo "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,INDEX,ALTER,CREATE TEMPORARY TABLES,LOCK TABLES ON Rivendell.* TO 'rduser'@'%';" | mysql -u root

    #
    # Enable NFS Access for all remote hosts
    #
    echo "/var/snd *(rw,no_root_squash)" >> /etc/exports
    echo "/home/rd/rd_xfer *(rw,no_root_squash)" >> /etc/exports
    echo "/home/rd/music_export *(rw,no_root_squash)" >> /etc/exports
    echo "/home/rd/music_import *(rw,no_root_squash)" >> /etc/exports
    echo "/home/rd/traffic_export *(rw,no_root_squash)" >> /etc/exports
    echo "/home/rd/traffic_import *(rw,no_root_squash)" >> /etc/exports
    chkconfig nfs on

    #
    # Enable CIFS File Sharing
    #
    chkconfig smb on
    chkconfig nmb on
fi

if test $MODE = "standalone" ; then
    #
    # Install MySQL
    #
    yum -y install mysql-server
    service mysqld start
    chkconfig mysqld on

    #
    # Enable CIFS File Sharing
    #
    chkconfig smb on
    chkconfig nmb on    
fi

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
mv /etc/samba/smb.conf /etc/samba/smb.conf-original
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
chmod 775 /home/rd
patch /etc/gdm/custom.conf /usr/share/rivendell-install/autologin.patch
yum -y install lame rivendell

if test $MODE = "client" ; then
    #
    # Add Remote Mounts
    #
    echo "$IP_ADDR:/var/snd /var/snd nfs defaults 0 0" >> /etc/fstab
    echo "$IP_ADDR:/home/rd/rd_xfer /home/rd/rd_xfer nfs defaults 0 0" >> /etc/fstab
    echo "$IP_ADDR:/home/rd/music_export /home/rd/music_export nfs defaults 0 0" >> /etc/fstab
    echo "$IP_ADDR:/home/rd/music_import /home/rd/music_import nfs defaults 0 0" >> /etc/fstab
    echo "$IP_ADDR:/home/rd/traffic_export /home/rd/traffic_export nfs defaults 0 0" >> /etc/fstab
    echo "$IP_ADDR:/home/rd/traffic_import /home/rd/traffic_import nfs defaults 0 0" >> /etc/fstab

    #
    # Configure Rivendell
    #
    cat /etc/rd.conf | sed s/localhost/$IP_ADDR/g > /etc/rd-temp.conf
    rm -f /etc/rd.conf
    mv /etc/rd-temp.conf /etc/rd.conf
fi

#
# Finish Up
#
echo
echo "Installation of Rivendell is complete.  Reboot now."
echo
echo "IMPORTANT: Be sure to see the FINAL DETAILS section in the instructions"
echo "           to ensure that your new Rivendell system is properly secured."
echo
