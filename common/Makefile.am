## automake.am
##
## common/Makefile.am for the rivendell-install package.
##
##   (C) Copyright 2016 Fred Gleason <fredg@paravelsystems.com>
##
##   This program is free software; you can redistribute it and/or modify
##   it under the terms of the GNU General Public License version 2 as
##   published by the Free Software Foundation.
##
##   This program is distributed in the hope that it will be useful,
##   but WITHOUT ANY WARRANTY; without even the implied warranty of
##   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##   GNU General Public License for more details.
##
##   You should have received a copy of the GNU General Public
##   License along with this program; if not, write to the Free Software
##   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
##
## Use automake to process this into a Makefile.in

SUBDIRS = skel

EXTRA_DIST = adobe-linux-x86_64.repo\
             autologin.patch\
             disable-selinux.patch\
             docbook5.sh\
             qt_plugins_3.3rc\
             qtrc\
             rdairplay_skin.png\
             rdpanel_skin.png\
             Reyware.repo\
             RPM-GPG-KEY-adobe-linux\
             RPM-GPG-KEY-Reyware\
             smb.conf

CLEANFILES = *~

MAINTAINERCLEANFILES = *~\
                       Makefile.in
