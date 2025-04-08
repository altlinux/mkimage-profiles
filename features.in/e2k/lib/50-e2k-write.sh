#!/bin/bash -efu
# ALT: write Elbrus boot media
# public domain 2020 Michael Shigorin <mike@altlinux.org>
# http://altlinux.org/elbrus

error() { echo "$@" >&2; exit 1; }
usage() { error "Usage: $0 [-f] /path/to/alt-e2k.iso /dev/sdX1_or_/dev/sr0"; }

# "yes, this flash drive's filesystem can be overwritten"
force=
[ "$1" = "-f" ] && force=1 && shift

[ $# = 2  ] || usage
[ -s "$1" ] || usage
[ -b "$2" ] || usage

checkuid() { [ "$(id -u)" = 0 ] || error "$0: need to run as root"; }
format() { mkfs.ext2 -E packed_meta_blocks=1,num_backup_sb=1 -L altinst "$1"; }

# use a partition block device, not the whole disk one
checkpart() {
	dev="${1#/dev/}"
	[ -n "$dev" ] || usage
	[ -f "/sys/class/block/$dev/partition" ] || usage
}

case "$2" in
/dev/sr[0-9]*|dvd*|cd*)
	grep -qw "^$2" /proc/mounts && checkuid && umount -v "$2"
	echo "Writing DVD image..."
	growisofs -dvd-compat -Z "$2"="$1"
	;;
/dev/sd*)
	grep -qw "^$2" /proc/mounts && [ -z "$force" ] && error "$2 mounted"
	checkpart "$2"
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
		cur="$(sed -rn 's/^default=(.*)$/\1/p' "$dst/boot.conf")"
		grep -q "^label=${cur}_flash$" "$dst/boot.conf" && {
			echo -n "updating default boot target... "
			sed -i 's,^default=.*$,&_flash,' "$dst/boot.conf"
			echo "done"
		} ||:
	}

	echo -n "unmounting media... "
	umount "$src" "$dst" && rmdir "$src" "$dst"
	echo "done."
	;;
*)
	usage
	;;
esac
