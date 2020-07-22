#!/bin/sh

# install_rivendell_virtserv.sh
#
# Install a KVM hypervisor setup suitable for running Rivendell vhosts
#
#    Copyright (C) 2020 Fred Gleason <fredg@paravelsystems.com>
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
# Install Packages
#
yum -y install qemu-kvm libvirt libvirt-python libguestfs-tools virt-install virt-manager virt-top

#
# Enable and start the hypervisor
#
systemctl enable libvirtd
systemctl start libvirtd

#
# Finish Up
#
echo
echo "Installation of the hypervisor tools is complete."
echo
