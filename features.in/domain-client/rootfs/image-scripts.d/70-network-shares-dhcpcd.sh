#!/bin/sh -efu

dhcpcd_conf="/etc/dhcpcd.conf"

[ -f "$dhcpcd_conf" ] || exit 0

grep -q '^option[[:blank:]]\+vendor_encapsulated_options' "$dhcpcd_conf" || {
	echo "# added by 70-network-shares-dhcpcd.sh"
	echo "option vendor_encapsulated_options"
} >> "$dhcpcd_conf"
