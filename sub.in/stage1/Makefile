# step 4: build stage1 subprofile (installer bootstrap)

include $(GLOBAL_BUILDDIR)/.config.mk
include $(GLOBAL_BUILDDIR)/functions.mk
include $(MKIMAGE_PREFIX)/config.mk

CHROOT_PACKAGES_REGEXP = $(call kpackages)
CHROOT_PACKAGES = $(STAGE1_PACKAGES) $(COMMON_PACKAGES)

MKI_PACK_RESULTS = data
###
PROPAGATOR_VERSION = mkimage-profiles 2.0
PROPAGATOR_MAR_MODULES = ./modules
PROPAGATOR_INITFS = ./initfs
COPY_TREE = ./files

include $(MKIMAGE_PREFIX)/targets.mk

all: build-propagator copy-tree copy-isolinux run-scripts pack-image
