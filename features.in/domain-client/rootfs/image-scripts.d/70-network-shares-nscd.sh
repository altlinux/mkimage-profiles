#!/bin/sh
# bump name services caching time up

[ -s /etc/nscd.conf ] || exit 0

sed -i 's/\(positive-time-to-live[^0-9]*\)[0-9]*$/\1 31536000/g' /etc/nscd.conf
