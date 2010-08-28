default: all

include $(GLOBAL_BUILDDIR)/globals.mk
include $(GLOBAL_BUILDDIR)/functions.mk
include $(MKIMAGE_PREFIX)/config.mk
include $(GLOBAL_BUILDDIR)/.config.mk

IMAGE_PACKAGES = kernel-image-std-def \
		 installer-distro-server-light-stage2 \
		 ./packages \
		 $(INSTALL2_PACKAGES)

MKI_PACK_RESULTS = squash:altinst

include $(MKIMAGE_PREFIX)/targets.mk

all: build-image run-image-scripts pack-image
