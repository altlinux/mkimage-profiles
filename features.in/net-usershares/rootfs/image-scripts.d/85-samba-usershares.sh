#!/bin/sh -efu

[ -s /etc/samba/smb.conf ] || exit 0

. shell-config

USERSHARES_DIR="/var/lib/samba/usershares"
USERSHARES_GROUP="sambashare"
DEFAULT_GROUPS='cdwriter cdrom audio video proc radio camera floppy xgrp scanner uucp'
GROUPS_FILE="/usr/share/install3/default-groups"

mkdir -p "$USERSHARES_DIR"
groupadd -r "$USERSHARES_GROUP"
chown root:"$USERSHARES_GROUP" "$USERSHARES_DIR"
chmod 1770 "$USERSHARES_DIR"

USERSHARES_OPTIONS="# ----------------------- User Shares Options -------------------------\n\tusershare path = $USERSHARES_DIR\n\tusershare max shares = 100\n\tusershare allow guests = yes\n\tusershare owner only = yes"

sed -i -e "\|^\[global\]|a$USERSHARES_OPTIONS" \
        -e "s/workgroup = MYGROUP/workgroup = WORKGROUP/" \
        "/etc/samba/smb.conf"

# Create group file for alterator-users
if [ ! -s "$GROUPS_FILE" ]; then
        mkdir -p "${GROUPS_FILE%/*}"
        echo "$DEFAULT_GROUPS" >"$GROUPS_FILE"
fi

# Add USERSHARES_GROUP to the default groups list.
echo "$USERSHARES_GROUP" >>"$GROUPS_FILE"

# Permissions for home dir must be 0701
tab="$(printf "\t")"
shell_config_set "/etc/login.defs" UMASK 076 "$tab" "$tab"

# smb and nmb services must be enabled
