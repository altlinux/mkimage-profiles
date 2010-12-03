# step 4: build install2 subprofile (installer "live" part)

default: all

include $(GLOBAL_BUILDDIR)/.config.mk
include $(GLOBAL_BUILDDIR)/functions.mk
include $(MKIMAGE_PREFIX)/config.mk

IMAGE_PACKAGES_REGEXP = $(call kpackages)
IMAGE_PACKAGES = $(COMMON_PACKAGES) \
		 $(INSTALL2_PACKAGES) \
		 ./packages

MKI_PACK_RESULTS = squash:altinst

include $(MKIMAGE_PREFIX)/targets.mk

all: build-image run-image-scripts pack-image
