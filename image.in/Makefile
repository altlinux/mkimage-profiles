include globals.mk
include functions.mk
include $(MKIMAGE_PREFIX)/config.mk
include $(GLOBAL_BUILDDIR)/.config.mk

SUBDIRS = $(SUBPROFILES)

# we usually need a bootloader (until stage1 is separate),
# and "main" subprofile needs genbasedir
CHROOT_PACKAGES = syslinux apt-utils $(STAGE1_PACKAGES)

###
MKI_PACK_RESULTS = boot:mkimage-profiles.iso
COPY_TREE = ./isodata
BOOT_TYPE = isolinux

###
PROPAGATOR_VERSION = mkimage-profiles 2.0
PROPAGATOR_MAR_MODULES = ./modules
PROPAGATOR_INITFS = ./initfs

include /usr/share/mkimage/targets.mk

all: prep copy-tree copy-subdirs run-scripts pack-image

prep: initfs disk-info metadata
	@echo "TOPDIR=$(TOPDIR)"

initfs:
	echo "file	/.VERSION	@TMPDIR@/.VERSION	0644	0 0" >initfs
	### FIXME: broken test, we already do branding
	[ -z "$(BRANDING)" ] || \
		echo "file	/bootsplash	/bootsplash/bootsplash	0644	0 0" >>initfs

disk-info:
	mkdir -p isodata/.disk
	echo "$(PROPAGATOR_VERSION)" >isodata/.disk/info	### +$(ARCH)
	(cd $(TOPDIR); git show-ref --head --dereference -s -- HEAD 2>/dev/null) >isodata/.disk/commit
	[ -s isodata/.disk/commit ] || rm isodata/.disk/commit

# see also alterator-pkg (backend3/pkg-install)
# FIXME: groups unmerged
metadata:
	mkdir -p isodata/Metadata
	rm -f isodata/Metadata/pkg-groups.tar
	tar -cvf isodata/Metadata/pkg-groups.tar \
		-C $(PKGDIR) \
		$(shell echo $(call list,.base) $(call list,base) | sed 's,$(PKGDIR)/*,,g')

