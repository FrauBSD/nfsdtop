############################################################ IDENT(1)
#
# $Title: Makefile for installing nfsdtop $
# $Copyright: 2020 Devin Teske. All rights reserved. $
# $FrauBSD: nfsdtop/GNUmakefile 2020-03-04 16:03:48 -0800 freebsdfrau $
#
############################################################ CONFIGURATION

DESTDIR=	
BINDIR=		$(DESTDIR)/usr/bin

############################################################ PATHS

CP_F=		cp -f
MKDIR_P=	mkdir -p
RM_F=		rm -f

############################################################ OBJECTS

NFSDTOP=	nfsdtop

############################################################ TARGETS

all:
	@printf "Options:\n"
	@printf "\tmake install\tInstall nfsdtop\n"
	@printf "\tmake uninstall\tUninstall nfsdtop\n"

install:
	$(MKDIR_P) $(BINDIR)
	$(CP_F) $(NFSDTOP) $(BINDIR)/

uninstall:
	$(RM_F) $(BINDIR)/$(NFSDTOP)

################################################################################
# END
################################################################################
