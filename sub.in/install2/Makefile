default: all

include $(GLOBAL_BUILDDIR)/.config.mk
include $(GLOBAL_BUILDDIR)/functions.mk
include $(MKIMAGE_PREFIX)/config.mk

# FIXME: hardwired
#IMAGE_PACKAGES_REGEXP = $(call kimage)
# NB: due to #24669, IMAGE_PACKAGES_REGEXP does need quoting here
IMAGE_PACKAGES_REGEXP = "$(call kpackages)"
#IMAGE_PACKAGES_REGEXP = "$(KERNEL_PACKAGES_REGEXP)"
#IMAGE_PACKAGES_REGEXP = ^kernel-image-(std-def|el-smp)$$
IMAGE_PACKAGES = $(COMMON_PACKAGES) \
		 $(INSTALL2_PACKAGES) \
		 ./packages

MKI_PACK_RESULTS = squash:altinst

include $(MKIMAGE_PREFIX)/targets.mk

all: build-image run-image-scripts pack-image
