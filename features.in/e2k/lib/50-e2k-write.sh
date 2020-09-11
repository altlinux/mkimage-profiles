#!/bin/sh -efu
# ALT: write Elbrus boot media
# public domain 2020 Michael Shigorin <mike@altlinux.org>
# http://altlinux.org/elbrus

error() { echo "$@" >&2; exit 1; }
usage() { error "Usage: $0 /path/to/alt-e2k.iso /dev/sdX1_or_/dev/sr0"; }

[ $# = 2  ] || usage
[ -s "$1" ] || usage
[ -b "$2" ] || usage

checkuid() { [ "$(id -u)" = 0 ] || error "$0: need to run as root"; }
format() { mkfs.ext2 -E packed_meta_blocks=1,num_backup_sb=1 -L altinst "$1"; }

case "$2" in
/dev/sr[0-9]*|dvd*|cd*)
	grep -qw "^$2" /proc/mounts && checkuid && umount -v "$2"
	echo "Writing DVD image..."
	growisofs -dvd-compat -Z "$2"="$1"
	;;
/dev/sd*)
	grep -q "^$1" /proc/mounts && error "$1 mounted already"
	checkuid
	[ "$(blkid -o value -s LABEL "$2")" = "altinst" ] || format "$2"
	src="$(mktemp -d)"
	dst="$(mktemp -d)"
	echo -n "mounting image... "
	mount -o loop,ro "$1" "$src"; echo "done"
	echo -n "mounting drive... "
	mount -o noatime "$2" "$dst"; echo "done"
	echo "copying contents..."
	rsync -Pavc --inplace --delete --numeric-ids "$src/" "$dst/" ||
		cp -avt "$dst" -- "$src"/{.disk,*}
	grep -q "^default=.*_flash$" "$dst/boot.conf" || {
		echo -n "updating default boot target... "
		sed -i 's,default=.*$,&_flash,' "$dst/boot.conf"
		echo "done"
	}
	echo -n "unmounting media... "
	umount "$src" "$dst"
	echo "done."
	;;
*)
	usage
	;;
esac
