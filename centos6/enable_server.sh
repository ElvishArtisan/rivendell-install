#!/bin/sh

# enable_server.sh
#
# Enable Rivendell server operations on a RHEL-6 host.
#
# (C) Copyright 2016 Fred Gleason <fredg@paravelsystems.com>
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of version 2 of the GNU General Public License as
#    published by the Free Software Foundation;
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, 
#    Boston, MA  02111-1307  USA
#

#
# Enable DB Access for all remote hosts
#
echo "CREATE USER 'rduser'@'%' IDENTIFIED BY 'letmein';" | mysql -u root -p

echo "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,INDEX,ALTER,CREATE TEMPORARY TABLES,LOCK TABLES ON Rivendell.* TO 'rduser'@'%';" | mysql -u root -p

#
# Enable NFS Access for all remote hosts
#
echo "/var/snd *(rw,no_root_squash)" >> /etc/exports
echo "/home/rd/rd_xfer *(rw,no_root_squash)" >> /etc/exports
echo "/home/rd/export_music *(rw,no_root_squash)" >> /etc/exports
echo "/home/rd/import_music *(rw,no_root_squash)" >> /etc/exports
echo "/home/rd/export_traffic *(rw,no_root_squash)" >> /etc/exports
echo "/home/rd/import_traffic *(rw,no_root_squash)" >> /etc/exports
service nfs restart
