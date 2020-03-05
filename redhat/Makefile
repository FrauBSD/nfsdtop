# -*- tab-width: 4 -*- ;; Emacs
# vi: set noexpandtab  :: Vi/ViM
# vi: set syntax=make  ::
################################################################################
################################ CONFIGURATION #################################
################################################################################

PKGCENTER      = ..
SPECFILE       = ./SPECFILE
STAGEDIR       = ./stage
PKGCENTER_CONF = ./pkgcenter.conf

################################################################################
############################# TARGET  DEPENDENCIES #############################
################################################################################

#
# Environment
#
ENVIRON = PKGCENTER=$(PKGCENTER) \
          SPECFILE=$(SPECFILE) \
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
RPMBUILD      = rpmbuild
RPMBUILDFLAGS = -bb

#
# Generated files
#
GENERATED_FILES = \
	.rpmmacros

#
# Package Specifics
#
CWD     = $$($(PWD))
NAME    = $$($(PKGCENTER)/Mk/rpmname "$(SPECFILE)")
TAG     = $$($(PKGCENTER)/Mk/rpmtag "$(NAME)")
TAGNAME = $$($(PKGCENTER)/Mk/rpmtagname "$(SPECFILE)")
GROUP   = $$($(PKGCENTER)/Mk/rpmgroup "$(SPECFILE)")

#
# Standard utility pathnames
#
CAT   = cat
GIT   = git
MKDIR = mkdir
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

.PHONY: all dirs symlinks stage forcestage specfile check_name rpm

all: stage dirs symlinks rpm

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

specfile: $(SPECFILE)

check_name: specfile
	@[ "$(NAME)" ] || $(PKGCENTER)/Mk/die \
		"ERROR: Specification $(SPECFILE) has no RPM name"

.rpmmacros:
	@:> $(@)
	@echo "#XXX NOTE: escaped %% for use in headerSprintf()" >> $(@)
	@echo "%_build_name_fmt" \
	      "%%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm" >> $(@)
	@echo >> $(@)
	@echo "%_srcdir $(STAGEDIR)" >> $(@)
	@echo >> $(@)
	@echo "%_topdir $(CWD)" >> $(@)
	@echo "%_builddir %{_topdir}" >> $(@)
	@echo "%_rpmdir %{_topdir}" >> $(@)
	@echo "%_sourcedir %{_topdir}" >> $(@)
	@echo "%_buildrootdir %{_topdir}" >> $(@)
	@echo "%_specdir %{_topdir}" >> $(@)
	@echo "%_srcrpmdir %{_topdir}" >> $(@)
	@echo "%_tmppath %{_topdir}/tmp" >> $(@)
	@echo >> $(@)
	@echo "%debug_package %{nil}" >> $(@)

rpm: check_name .rpmmacros
	HOME="$(CWD)" $(RPMBUILD) $(RPMBUILDFLAGS) $(SPECFILE)

#
# Package Maintenance Targets
#

.PHONY: conf clean distclean

conf:
	@$(ENVIRON) $(PKGCENTER)/Mk/rpmconf

srcfiles:
	@$(ENVIRON) $(PKGCENTER)/Mk/rpmsrcfiles

stagefiles: stage
	@$(ENVIRON) $(PKGCENTER)/Mk/rpmstagefiles

clean:
	$(RM) -f $(GENERATED_FILES)
	$(RM) -Rf tmp
	@$(SYMLINKS) $(PKGCENTER)/Mk/clean_symlinks
	@$(DIRS) $(PKGCENTER)/Mk/clean_directories
	[ -e .keep-stage ] || $(RM) -Rf $(STAGEDIR)

distclean: clean
	$(RM) -f *.rpm

#
# Git Maintenance Targets
#

.PHONY: check_tag tag forcetag taglist

check_tag:
	@[ "$(TAG)" ] || $(PKGCENTER)/Mk/die \
	    "ERROR: Specification $(SPECFILE) has invalid RPM name"

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
	@$(CAT) $(PKGCENTER)/Mk/USAGE_RPM

targets help:
	@$(CAT) $(PKGCENTER)/Mk/HELP_RPM

################################################################################
# END
################################################################################
