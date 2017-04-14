#!/bin/sh
# Disable tracker on live

XDG_AS_DIR=/etc/xdg/autostart
LIVE_USER=altlinux
LIVE_USER_HOME="/home/$LIVE_USER"

if [ -d "$LIVE_USER_HOME/.config/autostart" ]; then
	for d in extract miner-apps miner-fs miner-rss miner-user-guides store; do
		[ -f "$XDG_AS_DIR"/tracker-$d.desktop ] || continue
		cat <<EOF >$LIVE_USER_HOME/.config/autostart/tracker-$d.desktop
[Desktop Entry]
Hidden=true
EOF
		chown "$LIVE_USER":"$LIVE_USER" $LIVE_USER_HOME/.config/autostart/tracker-$d.desktop
	done
fi
