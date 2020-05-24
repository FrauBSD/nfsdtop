############################################################ IDENT(1)
#
# $Title: Makefile for installing nfsdtop on Linux $
# $Copyright: 2020 Devin Teske. All rights reserved. $
# $FrauBSD: nfsdtop/GNUmakefile 2020-05-23 19:12:14 -0700 freebsdfrau $
#
############################################################ CONFIGURATION

DESTDIR=	
BINDIR=		$(DESTDIR)/usr/bin

############################################################ PATHS

CP_F=		cp -f
MKDIR_P=	mkdir -p
RM_F=		rm -f

############################################################ OBJECTS

PROG=		nfsdtop
SRC=		nfsdtop.linux

############################################################ TARGETS

all:
	@printf "Options:\n"
	@printf "\tmake install\tInstall $(PROG)\n"
	@printf "\tmake uninstall\tUninstall $(PROG)\n"

install:
	$(MKDIR_P) $(BINDIR)
	$(CP_F) $(SRC) $(BINDIR)/$(PROG)

uninstall:
	$(RM_F) $(BINDIR)/$(PROG)

################################################################################
# END
################################################################################
