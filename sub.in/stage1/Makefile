include $(GLOBAL_BUILDDIR)/.config.mk
include $(GLOBAL_BUILDDIR)/functions.mk
include $(MKIMAGE_PREFIX)/config.mk

# FIXME: hardwired
#CHROOT_PACKAGES_REGEXP = $(call kimage)
# NB: see #24669, CHROOT_PACKAGES_REGEXP does NOT need quoting here
CHROOT_PACKAGES_REGEXP = $(call kpackages)
#CHROOT_PACKAGES_REGEXP = "$(KERNEL_PACKAGES_REGEXP)"
#CHROOT_PACKAGES_REGEXP = ^kernel-image-(std-def|el-smp)$$ ^kernel-modules-(ipset|kvm|ndiswrapper|pf_ring|xtables-addons)-(el-smp|ovz-smp)$$
CHROOT_PACKAGES = $(STAGE1_PACKAGES) $(COMMON_PACKAGES)

MKI_PACK_RESULTS = data
###
PROPAGATOR_VERSION = mkimage-profiles 2.0
PROPAGATOR_MAR_MODULES = ./modules
PROPAGATOR_INITFS = ./initfs
COPY_TREE = ./files

include $(MKIMAGE_PREFIX)/targets.mk

all: build-propagator copy-tree copy-isolinux run-scripts pack-image
