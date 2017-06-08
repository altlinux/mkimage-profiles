#!/bin/sh
# Customize live installer

[ -d /etc/livecd-install ] || exit 0

# Use custom luks step
sed -i 's;^luks$;slinux-luks;' /etc/livecd-install/steps
