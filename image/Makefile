include /usr/share/mkimage/config.mk

SUBDIRS = stage2
CHROOT_PACKAGES = kernel-image-un-def apt-utils

MKI_PACK_RESULTS = boot:mkimage-profiles.iso
COPY_TREE = ./isodata
BOOT_TYPE = isolinux

PROPAGATOR_VERSION = mkimage-profiles 2.0
PROPAGATOR_MAR_MODULES = ./modules
PROPAGATOR_INITFS = ./initfs

include /usr/share/mkimage/targets.mk

all: initfs copy-tree copy-subdirs run-scripts pack-image

initfs:
	echo "file	/.VERSION	@TMPDIR@/.VERSION	0644	0 0" > initfs
	#[ -z "$(BRANDING)" ] || \
	#	echo "file /bootsplash /bootsplash/bootsplash 0644 0 0" >> initfs
