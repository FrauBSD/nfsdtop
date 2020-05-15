# -*- tab-width: 4 -*- ;; Emacs
# vi: set noexpandtab  :: Vi/ViM
# vi: set syntax=make  ::
################################################################################
################################ CONFIGURATION #################################
################################################################################

PKGCENTER      = ..
MANIFEST       = ./MANIFEST
PLIST          = $(MANIFEST)
STAGEDIR       = ./stage
PKGCENTER_CONF = ./pkgcenter.conf

################################################################################
############################# TARGET  DEPENDENCIES #############################
################################################################################

#
# Environment
#
ENVIRON = PKGCENTER=$(PKGCENTER) \
          MANIFEST=$(MANIFEST) \
          PLIST=$(PLIST) \
          STAGEDIR=$(STAGEDIR) \
          PKGCENTER_CONF=$(PKGCENTER_CONF)

#
# Macro for reading pkgcenter.conf
#
SOURCE_CONF = $(ENVIRON) $(PKGCENTER)/Mk/pkgcenter_readconf $(PKGCENTER_CONF)

#
# Pulled from pkgcenter.conf -- configured above.
#
DIRS     = $(SOURCE_CONF) DIRS     | $(PKGCENTER)/Mk/xargs
SYMLINKS = $(SOURCE_CONF) SYMLINKS | $(PKGCENTER)/Mk/xargs -n 1024
STAGE    = $(SOURCE_CONF) STAGE    | $(PKGCENTER)/Mk/xargs -n 1024

################################################################################
############################### GLOBAL VARIABLES ###############################
################################################################################

#
# Package tools
#
PKGCC        = $(PKGCENTER)/freebsd/Mk/pkgcc
PKGCCFLAGS   = -y
CONVERT      = $(PKGCENTER)/freebsd/Mk/convert
CONVERTFLAGS = -f
TAR          = tar
TARFLAGS     = c --exclude CVS -f
TARSUFFIX    = tar
ZIP          = xz
ZIPSUFFIX    = xz
SUFFIX       = txz

#
# Generated files
#
GENERATED_FILES = \
	$(STAGEDIR)/+MANIFEST \
	$(STAGEDIR)/+COMPACT_MANIFEST

#
# Package Specifics
#
CWD     = $$($(PWD))
NAME    = $$($(PKGCENTER)/freebsd/Mk/pkgname "$(PLIST)")
TAG     = $$($(PKGCENTER)/freebsd/Mk/pkgtag "$(NAME)")
TAGNAME = $$($(PKGCENTER)/freebsd/Mk/pkgtagname "$(PLIST)")
ORIGIN  = $$($(PKGCENTER)/freebsd/Mk/pkgorigin "$(PLIST)")

#
# Standard utility pathnames
#
CAT   = cat
GIT   = git
MKDIR = mkdir
MV    = mv
PWD   = pwd
RM    = rm

################################################################################
############################## FUNCTION VARIABLES ##############################
################################################################################

EVAL2 = eval2(){ echo "$$@"; eval "$$@"; }

################################################################################
################################ BUILD  TARGETS ################################
################################################################################

#
# Package Building Targets
#

.PHONY: all dirs symlinks stage forcestage plist check_name package

all: stage dirs symlinks package

dirs:
	@echo "Creating directories..."
	@$(DIRS) $(PKGCENTER)/Mk/make_directories

symlinks:
	@echo "Creating symbolic links..."
	@$(SYMLINKS) $(PKGCENTER)/Mk/make_symlinks

stage:
	@echo "Copying stage dependencies..."
	@$(EVAL2); [ -e "$(STAGEDIR)" ] || eval2 $(MKDIR) -p $(STAGEDIR)
	@$(STAGE) $(PKGCENTER)/Mk/make_stage

forcestage:
	@echo "Copying [all] dependencies..."
	@$(EVAL2); [ -e "$(STAGEDIR)" ] || eval2 $(MKDIR) -p $(STAGEDIR)
	@$(STAGE) $(PKGCENTER)/Mk/make_stage -f

$(PLIST):
	@$(EVAL2); [ "$(PLIST)" = "$(MANIFEST)" -o \
	 	"$(PLIST)" -nt "$(MANIFEST)" ] || eval2 $(CONVERT) \
	 	$(CONVERTFLAGS) $(MANIFEST) $(PLIST) $(STAGEDIR)

plist: $(PLIST)

check_name: plist
	@[ "$(NAME)" ] || $(PKGCENTER)/Mk/die \
	    "ERROR: Package $(PLIST) has no package name"

package: check_name
	$(PKGCC) $(PKGCCFLAGS) $(PLIST) $(STAGEDIR)
	@$(EVAL2); cwd=$(CWD); name=$(NAME);            \
	 eval2 cd $(STAGEDIR) || exit;                  \
	 TARFILE=$$cwd/$$name.$(TARSUFFIX);             \
	 if tar --help 2>&1 | grep -q bsdtar; then      \
	     vers=$$( tar --version 2> /dev/null );     \
	     case "$${vers#"$${vers%%[0-9]*}"}" in      \
	     [0-2].*) TRANSFORM=':^[^+]:/~:' ;;         \
	           *) TRANSFORM=':^[^+]:/~:S' ;;        \
	     esac;                                      \
	     TARFLAGS2="-s '$$TRANSFORM' -P";           \
	 else                                           \
	     TARFLAGS2="--transform 's:^[^+]:/&:S' -P"; \
	 fi;                                            \
	 eval2 $(TAR) $(TARFLAGS) $$TARFILE $$TARFLAGS2 * || exit; \
	 ! type "$(ZIP)" > /dev/null 2>&1 && exit;      \
	 eval2 $(ZIP) $$TARFILE || exit;                \
	 eval2 $(MV) -f $$TARFILE.$(ZIPSUFFIX) $$cwd/$$name.$(SUFFIX)
	@[ "$(ORIGIN)" ] || echo "WARNING: Empty or missing package origin"

#
# Package Maintenance Targets
#

.PHONY: clean distclean

clean:
	$(RM) -f $(GENERATED_FILES)
	@$(SYMLINKS) $(PKGCENTER)/Mk/clean_symlinks
	@$(DIRS) $(PKGCENTER)/Mk/clean_directories
	[ -e .keep-stage ] || $(RM) -Rf $(STAGEDIR)
	@$(EVAL2); [ "$(MANIFEST)" = "$(PLIST)" ] || eval2 $(RM) -f $(PLIST)

distclean: clean
	$(RM) -f *.$(TARSUFFIX) *.$(SUFFIX)

#
# Git Maintenance Targets
#

.PHONY: check_tag tag forcetag taglist

check_tag:
	@[ "$(TAG)" ] || $(PKGCENTER)/Mk/die \
	    "ERROR: Package $(PLIST) has invalid package name"

tag: check_tag
	@$(ENVIRON) $(PKGCENTER)/Mk/git_tag "$(TAG)"

forcetag: check_tag
	@$(ENVIRON) $(PKGCENTER)/Mk/git_tag -f "$(TAG)"

taglist:
	@$(ENVIRON) $(PKGCENTER)/Mk/git_tag -l "$(TAGNAME)-*"

#
# Git Addition Targets
#

.PHONY: import commit pull

import:
	@$(ENVIRON) $(PKGCENTER)/Mk/git_import

autoimport:
	@$(ENVIRON) $(PKGCENTER)/Mk/git_import -a

commit:
	@$(GIT) commit

pull:
	@$(GIT) pull

#
# Generic Targets
#

.PHONY: usage targets help

usage:
	@$(CAT) $(PKGCENTER)/freebsd/Mk/USAGE_PACKAGE

targets help:
	@$(CAT) $(PKGCENTER)/freebsd/Mk/HELP_PACKAGE

################################################################################
# END
################################################################################
