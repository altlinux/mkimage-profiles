# step 4: build install2 subprofile (installer "live" part)

ifndef GLOBAL_BUILDDIR
$(error GLOBAL_BUILDDIR not defined)
endif

default: all

include $(GLOBAL_BUILDDIR)/distcfg.mk
include $(GLOBAL_BUILDDIR)/functions.mk
include $(MKIMAGE_PREFIX)/config.mk

# need kernel modules only (which require corresponding kernel-image);
# these go into work chroot; NB: no vmlinuz there
IMAGE_PACKAGES_REGEXP = $(call kpackages,$(KMODULES),$(KFLAVOURS))
IMAGE_PACKAGES = $(COMMON_PACKAGES) \
		 $(INSTALL2_PACKAGES) \
		 ./packages

MKI_PACK_RESULTS = squash:altinst

include $(MKIMAGE_PREFIX)/targets.mk

all: build-image run-image-scripts pack-image
