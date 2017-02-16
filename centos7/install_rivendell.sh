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
yum -y install patch evince telnet lwmon nc samba qt3-config polymer paravelview ntp emacs twolame libmad nfs-utils cifs-utils samba-client ssvnc xfce4-screenshooter net-tools alsa-utils cups tigervnc-server-minimal pygtk2 cups system-config-printer gedit

if test $MODE = "server" ; then
    #
    # Install MariaDB
    #
    yum -y install mariadb-server
    systemctl start mariadb
    systemctl enable mariadb
    mkdir -p /etc/systemd/system/mariadb.service.d/
    cp /usr/share/rivendell-install/limits.conf /etc/systemd/system/mariadb.service.d/
    systemctl daemon-reload

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
    systemctl enable rpcbind
    systemctl enable nfs-server

    #
    # Enable CIFS File Sharing
    #
    systemctl enable smb
    systemctl enable nmb
fi

if test $MODE = "standalone" ; then
    #
    # Install MariaDB
    #
    yum -y install mariadb-server
    systemctl start mariadb
    systemctl enable mariadb
    mkdir -p /etc/systemd/system/mariadb.service.d/
    cp /usr/share/rivendell-install/limits.conf /etc/systemd/system/mariadb.service.d/
    systemctl daemon-reload

    #
    # Enable CIFS File Sharing
    #
    systemctl enable smb
    systemctl enable nmb
fi

#
# Install Rivendell
#
patch /etc/selinux/config /usr/share/rivendell-install/disable-selinux.patch
systemctl disable firewalld
yum -y remove chrony
systemctl start ntpd
systemctl enable ntpd
rm -f /etc/asound.conf
cp /usr/share/rivendell-install/visual.sh /etc/profile.d/
cp /usr/share/rivendell-install/asound.conf /etc/
cp /usr/share/rivendell-install/*.repo /etc/yum.repos.d/
cp /usr/share/rivendell-install/RPM-GPG-KEY* /etc/pki/rpm-gpg/
mkdir -p /usr/share/pixmaps/rivendell
cp /usr/share/rivendell-install/rdairplay_skin.png /usr/share/pixmaps/rivendell/
cp /usr/share/rivendell-install/rdpanel_skin.png /usr/share/pixmaps/rivendell/
mv /etc/samba/smb.conf /etc/samba/smb-original.conf
cp /usr/share/rivendell-install/smb.conf /etc/samba/
cp /usr/share/rivendell-install/no_screen_blank.conf /etc/X11/xorg.conf.d/
mkdir -p /etc/skel/Desktop
cp /usr/share/rivendell-install/skel/rog-1.3.3.pdf /etc/skel/Desktop/Rivendell\ Ops\ Guide.pdf
cp /usr/share/rivendell-install/skel/paravel_support.pdf /etc/skel/Desktop/First\ Steps.pdf
mkdir -p /etc/skel/.qt
cp /usr/share/rivendell-install/qt_plugins_3.3rc /etc/skel/.qt/
cp /usr/share/rivendell-install/qtrc /etc/skel/.qt/
adduser -c Rivendell\ Audio --groups audio rd
mkdir -p /home/rd/rd_xfer
mkdir -p /home/rd/music_export
mkdir -p /home/rd/music_import
mkdir -p /home/rd/traffic_export
mkdir -p /home/rd/traffic_import
chown -R rd:rd /home/rd
chmod 0755 /home/rd
patch /etc/gdm/custom.conf /usr/share/rivendell-install/autologin.patch
yum -y remove alsa-firmware alsa-firmware-tools
yum -y install rivendell

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
