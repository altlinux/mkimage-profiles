#!/bin/sh
# this script is run during an individual feature configuration
# (that is, while building the actual profile from subprofiles
# and requested features); it can be more comfortable for extensive
# shell scripting than embedding into a makefile recipe with all
# the quoting and so on
#
# please note, it runs *after* copying subdirectories corresponding
# to requested subprofiles and *before* running generate.sh, see also
# features.in/Makefile
#
# for a real-world example, see syslinux feature

# route stdout to stderr
exec >&2

# dump environment
echo "--- $0 ---"
env
echo "--- $0 ---"
