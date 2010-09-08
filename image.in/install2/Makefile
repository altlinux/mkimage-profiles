default: all

include ../globals.mk
include ../functions.mk
include $(MKIMAGE_PREFIX)/config.mk
include $(GLOBAL_BUILDDIR)/.config.mk

IMAGE_PACKAGES = $(KERNEL_PACKAGES) \
		 $(COMMON_PACKAGES) \
		 $(INSTALL2_PACKAGES) \
		 ./packages

MKI_PACK_RESULTS = squash:altinst

include $(MKIMAGE_PREFIX)/targets.mk

all: build-image run-image-scripts pack-image
