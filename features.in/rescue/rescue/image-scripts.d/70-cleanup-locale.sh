#!/bin/sh

find /usr/lib/locale /usr/share/locale -mindepth 1 -maxdepth 1 \
	-not -name 'C*' -exec rm -r {} \;

