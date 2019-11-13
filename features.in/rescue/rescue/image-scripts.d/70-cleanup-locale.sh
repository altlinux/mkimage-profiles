#!/bin/sh

# cleanup extra locales
CLEANUP_DIRS="/usr/lib/locale /usr/share/locale"

for CLEANUP_DIR in $CLEANUP_DIRS; do
cd "$CLEANUP_DIR"
rm -fr $(ls -1 |sed '/en_US/d' | tr -s '\r\n' ' ')
done
