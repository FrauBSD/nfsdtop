#!/bin/sh
############################################################ IDENT(1)
#
# $Title: Script to enable client side hooks $
# $Copyright: 2017 Devin Teske. All rights reserved. $
# $FrauBSD: nfsdtop/.git-hooks/install.sh 2020-03-04 15:58:16 -0800 freebsdfrau $
#
############################################################ GLOBALS

pgm="${0##*/}" # Program basename
progdir="${0%/*}" # Program directory

#
# Global exit status
#
SUCCESS=0
FAILURE=1

#
# Stdout processing
#
CONSOLE=
[ -t 0 ] && CONSOLE=1 # Output is to a terminal (vs pipe, etc.)

#
# ANSI
#
ESC=$( :| awk 'BEGIN { printf "%c", 27 }' )
ANSI_BLD_ON="${CONSOLE:+$ESC[1m}"
ANSI_BLD_OFF="${CONSOLE:+$ESC[22m}"
ANSI_GRN_ON="${CONSOLE:+$ESC[32m}"
ANSI_FGC_OFF="${CONSOLE:+$ESC[39m}"

#
# Command-line options
#
FORCE=	# -f

############################################################ FUNCTIONS

usage()
{
	local optfmt="\t%-5s %s\n"
	exec >&2
	printf "Usage: %s [OPTIONS]\n" "$pgm"
	printf "OPTIONS:\n"
	printf "$optfmt" "-f" \
		"Force. Do not skip any steps for any reason."
	exit $FAILURE
}

have()
{
	type "$@" > /dev/null 2>&1
}

eval2()
{
	echo "$ANSI_BLD_ON$ANSI_GRN_ON==>$ANSI_FGC_OFF $*$ANSI_BLD_OFF"
	eval "$@"
}

eval3()
{
	echo "$ANSI_BLD_ON$ANSI_GRN_ON==>$ANSI_FGC_OFF $*$ANSI_BLD_OFF" >&3
	eval "$@"
}

############################################################ MAIN

set -e # Make all errors fatal
exec 3<&1

#
# Process command-line options
#
while getopts f flag; do
	case "$flag" in
	f) FORCE=1 ;;
	*) usage # NOTREACHED
	esac
done
shift $(( $OPTIND - 1 ))

#
# Information
#
eval2 : "progdir='$progdir'"

#
# Make symlinks in .git directory
#
linkdir="$progdir/../.git/hooks"
for file in $( find "$progdir" \
	-type f -and \
	-not -name '*.sh' \
	-and -not -name '.*' \
	-and -not -name '*[^[:alnum:]_-]*' \
	| sed -e 's#.*/##'
); do
	[ -x "$progdir/$file" ] || continue
	link="$linkdir/$file"
	target="../../.git-hooks/$file"
	if [ ! "$FORCE" ] && have readlink && [ -L "$link" ]; then
		linktarget=$( readlink "$link" )
		if [ "$linktarget" = "$target" ]; then
			echo "\`$link' -> \`$target'"
			continue
		fi
	fi
	eval2 ln -sfv \"\$target\" \"\$linkdir/\"
done

#
# Make sure name/email are set
#
name=$( eval3 git config user.name ) || :
if [ "$FORCE" -o ! "$name" ]; then
	default="${name:-$( id -nu )}"
	read -p "User name [$default]: " name
	git config user.name "${name:-$default}"
else
	echo "User name: $name"
fi
email=$( eval3 git config user.email ) || :
if [ "$FORCE" -o ! "$email" ]; then
	default="${email:-$( id -nu )@$( hostname )}"
	read -p "User email [$default]: " email
	git config user.email "${email:-$default}"
else
	echo "User email: $email"
fi

#
# Done
#
eval2 : SUCCESS
exit $SUCCESS

################################################################################
# END
################################################################################
