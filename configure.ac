dnl configure.ac
dnl
dnl Autoconf configuration for the rivendell_install package.
dnl
dnl Use autoconf to process this into a configure script
dnl
dnl   (C) Copyright 2016 Fred Gleason <fredg@paravelsystems.com>
dnl
dnl   This program is free software; you can redistribute it and/or modify
dnl   it under the terms of the GNU General Public License version 2 as
dnl   published by the Free Software Foundation.
dnl
dnl   This program is distributed in the hope that it will be useful,
dnl   but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl   GNU General Public License for more details.
dnl
dnl   You should have received a copy of the GNU General Public
dnl   License along with this program; if not, write to the Free Software
dnl   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
dnl

AC_INIT([rivendell-install],m4_esyscmd(cat PACKAGE_VERSION))
AM_INIT_AUTOMAKE
AC_SUBST(RPM_RELEASE,1)
m4_ifdef([AM_SILENT_RULES],[AM_SILENT_RULES([yes])])
AC_CONFIG_MACRO_DIR([m4])

#
# Option Switches
#
AC_ARG_ENABLE(docbook,[  --disable-docbook       disable building of documentation],[DOCBOOK_DISABLED=yes],[])

#
# Determine Distro
#
AR_GET_DISTRO()
AC_SUBST(DISTRO,$ar_gcc_distro)
if test $ar_distro_major -eq 7 ; then
  ln -s rivendell-install-rhel7.spec rivendell-install.spec
fi
if test $ar_distro_major -eq 6 ; then
  ln -s rivendell-install-rhel6.spec rivendell-install.spec
fi

#
# Build DocBook Items?
#
if test -z $DOCBOOK_DISABLED ; then
  USING_DOCBOOK=yes
fi
AM_CONDITIONAL([DOCBOOK_AM], [test "$USING_DOCBOOK" = yes])

#
# Configure RPM Build
#
AC_CHECK_PROG(RPMBUILD_FOUND,rpmbuild,[yes],[])
if test -z $RPMBUILD_FOUND ; then
  AC_SUBST(RPMBUILD,rpm)
else
  AC_SUBST(RPMBUILD,rpmbuild)
fi
if test -d /usr/src/redhat ; then
  AC_SUBST(VENDOR,redhat)
else
  AC_SUBST(VENDOR,suse)
fi 
AC_SUBST(RPM_DATESTAMP,`date +%a\ %b\ %d\ %Y`)

AC_CONFIG_FILES([ \
    centos6/Makefile \
    centos7/Makefile \
    common/Makefile \
    docs/Makefile \
    rivendell-install-rhel6.spec \
    rivendell-install-rhel7.spec \
    Makefile ])
AC_OUTPUT()

AC_MSG_NOTICE()
AC_MSG_NOTICE(Now enter 'make' to build the software.)
AC_MSG_NOTICE()
