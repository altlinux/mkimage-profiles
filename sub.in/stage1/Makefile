include ../globals.mk
include ../functions.mk
include $(MKIMAGE_PREFIX)/config.mk
include $(GLOBAL_BUILDDIR)/.config.mk

CHROOT_PACKAGES = syslinux $(KERNEL_PACKAGES)

###
MKI_PACK_RESULTS = data
PROPAGATOR_VERSION = mkimage-profiles 2.0
PROPAGATOR_MAR_MODULES = ./modules
PROPAGATOR_INITFS = ./initfs

include $(MKIMAGE_PREFIX)/targets.mk

all: build-propagator copy-isolinux run-scripts pack-image

