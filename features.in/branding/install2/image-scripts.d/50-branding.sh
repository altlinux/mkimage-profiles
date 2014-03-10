#!/bin/bash

[ -n "$GLOBAL_INSTALL2_BRANDING_SLIDESHOW" ] || exit 0

for arg in $GLOBAL_INSTALL2_BRANDING_SLIDESHOW; do
	echo "${arg/:/=}" >> /etc/alterator/slideshow.conf
done
