#!/bin/sh -efu

##
# This script:
#   1) updates pam_mount configuration
#   2) updates pam configuration
#
# NB: network shares automounted only for a particular uid range

. shell-error

msg() {
	printf "$* \n"
}

pmconf="/etc/security/pam_mount.conf.xml"
pamconf="/etc/pam.d/system-auth-krb5"

##
# Update pam_mount configuration file
#
update_pmconf() {

	local insert_at tmp_conf

	tmp_conf="${pmconf}.new"

	# no pam_mount: impossible(tm)
	[ -w "$pmconf" ] || return 1

	# already configured
	grep -qs dnssd_lookup "$pmconf" 2>/dev/null && return 0

	# configure pam_mount to use avahi
	insert_at="$(sed -n '/<!-- Volume definitions -->/=' "$pmconf" \
		| head -n 1)"

	if [ -z "$insert_at" ]; then
		msg "Can't find position for injection in $pmconf"
		return 1
	fi

	# part 1 (head)
	head -n $((insert_at-1)) "$pmconf" > "$tmp_conf"

	# part 2 (inserted text)
	cat >> "$tmp_conf" <<'__EOF__'

<!-- # inserted by 70-network-shares-samba.sh ##################### -->

<volume uid="5000-10000" fstype="cifs" dnssd_lookup="1" mountpoint="/home/%(USER)/share" options="sec=krb5,cruid=%(USERUID)" />
<cifsmount>/sbin/mount.cifs //%(SERVER)/%(VOLUME) %(MNTPT) -o %(OPTIONS)</cifsmount>
<cifsumount>/sbin/umount.cifs %(MNTPT)</cifsumount>

<!-- ############################################################## -->

__EOF__

	# part 3 (tail)
	sed -n "$insert_at,\$p" "$pmconf" >> "$tmp_conf"

	# update config
	chown root:root "$tmp_conf"
	chmod 644 "$tmp_conf"
	mv -f "$tmp_conf" "$pmconf"

	# XXX: REMOVE FOR RELEASE
	# sed -i -e '/debug enable/ s/0/1/' "$pmconf"
}

##
# Update pam configuration
#
update_pam() {
	local append_after

	# no pam-config: impossible(tm)
	[ -w "$pamconf" ] || return 1

	if [ -L "$pamconf" ]; then
		pamconf="$(realpath "$pamconf")"
	fi

	# already configured
	grep -qs pam_mount "$pamconf" && return 0

	append_after="$(sed -n '/^auth[[:space:]]\+required/=' "$pamconf" \
		| tail -n 1)"
	[ -n "$append_after" ] &&
		sed -i \
		-e "$append_after a auth     optional       pam_mount.so" \
		"$pamconf"

	append_after="$(sed -n '/^session[[:space:]]\+required/=' "$pamconf" \
		| tail -n 1)"
	[ -n "$append_after" ] &&
		sed -i \
		-e "$append_after a session  optional       pam_mount.so" \
		"$pamconf"
	append_after="$(sed -n '/^auth[[:space:]]\+required/=' \
		"$pamconf"_ccreds | tail -n 1)"

	[ -n "$append_after" ] &&
		sed -i \
		-e "$append_after a auth     optional       pam_mount.so" \
		"$pamconf"_ccreds

	### set ccache to predicadable value (ouch!)
	sed -i 's|pam_krb5.so use_first_pass$|pam_krb5.so use_first_pass ccache=/tmp/krb5cc_%u|' "$pamconf"
}

##
# Start
#
update_pmconf &&
update_pam

