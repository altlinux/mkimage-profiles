#!/bin/sh
# a script to help weed out duplicate packages
# contained in package lists given as arguments
#
# Requires: libshell

. /bin/shell-quote

sort "$@" \
| grep -v '^ *#' \
| sed  -s 's,[ 	]\+, ,g' \
| grep -v '^ *$' \
| uniq -cd \
| while read num str; do
	echo -n "$str: $num ";
	pattern="`quote_sed_regexp "$str"`"
	grep -l "^$pattern$" "$@" | tr '\n' ' '
	echo
done \
| sort -rn -t: -k2
