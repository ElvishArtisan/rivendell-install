## automake.am
##
## Top level automake.am for the rivendell-install package.
##
## Use automake to process this into a Makefile.in
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

if DOCBOOK_AM
  DOCBOOK_AM_OPT = docs
endif

SUBDIRS = centos6\
          centos7\
          common\
          $(DOCBOOK_AM_OPT)

ACLOCAL_AMFLAGS = -I m4

maintainer-clean-local:	
	rm -rf m4

rpm:	dist
	mkdir -p $(HOME)/rpmbuild/SOURCES
	cp rivendell-install-$(VERSION).tar.gz $(HOME)/rpmbuild/SOURCES/
	$(RPMBUILD) -ba --target noarch-$(VENDOR)-linux rivendell-install.spec
	mv $(HOME)/rpmbuild/RPMS/noarch/rivendell-install-*.rpm $(top_srcdir)/
	mv $(HOME)/rpmbuild/SRPMS/rivendell-install-*.src.rpm $(top_srcdir)/
	rm $(HOME)/rpmbuild/SOURCES/rivendell-install-$(VERSION).tar.gz

EXTRA_DIST = autogen.sh\
             get_distro.pl\
             get_target.sh\
             PACKAGE_VERSION\
             rivendell-install-rhel6.spec.in\
             rivendell-install-rhel7.spec.in

CLEANFILES = *~\
             *.mo\
             *.rpm\
             *.tar.gz\
             *.tgz\
             *.zip

DISTCLEANFILES = config.guess\
                 config.sub

MAINTAINERCLEANFILES = *~\
                       *.tar.gz\
                       aclocal.m4\
                       Makefile.in\
                       config.guess\
                       config.status\
                       config.sub\
                       configure\
                       depcomp\
                       install-sh\
                       libtool\
                       ltmain.sh\
                       missing\
                       mkinstalldirs\
                       rivendell-install.spec
