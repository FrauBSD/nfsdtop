# -*- tab-width:  4 -*- ;; Emacs
# vi: set noexpandtab   :: Vi/ViM
# vi: set filetype=spec ::
############################################################ HEADER

Name: @NAME@
Group: @GROUP@
# For a list of groups, see pkgcenter/redhat/Mk/GROUPS

Summary: @SUMMARY@
License: @LICENSE@
Version: @VERSION@
Release: @RELEASE@
Buildarch: @ARCH@

URL: @URL@
Packager: @PACKAGER@
Vendor: @VENDOR@

BuildRoot: %{_tmppath}/src

__REQUIRES__

__PROVIDES__

############################################################ DESCRIPTION

%Description
@DESCRIPTION@

############################################################ MACROS

#
# Define how we should install the files into the temporary
# install-root from which the RPM will be compiled.
#
%define TAR          %{__tar}
%define TARFROMFLAGS c --exclude CVS -f - -C
%define TARFILES     .
%define TARTOFLAGS   xvf - -C

#
# Short-hand
#
# NOTE: $RPM_BUILD_ROOT has a trailing-slash
#
%define TMPROOT $RPM_BUILD_ROOT

############################################################ INSTALL STANZA

%install
%{__mkdir_p} %{TMPROOT}
%{TAR} %{TARFROMFLAGS} %{_srcdir} %{TARFILES} | %{TAR} %{TARTOFLAGS} %{TMPROOT}

############################################################ FILES STANZA

%files
%defattr(-,root,root)
__FILE_LISTING__

############################################################ FOOTER

%pre
@PREIN@

%post
@POSTIN@

%preun
@PREUN@

%postun
@POSTUN@

%changelog
* @CHANGELOGTIME:day@ @CHANGELOGNAME@
@CHANGELOGTEXT@
