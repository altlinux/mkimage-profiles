### installation package base (requisite + optional)

default: all

include ../globals.mk
include ../functions.mk
include $(MKIMAGE_PREFIX)/config.mk
include $(GLOBAL_BUILDDIR)/.config.mk

CHROOT_PACKAGES = apt-utils rsync
PACKAGES_EXPAND_METHOD=regexp

IMAGE_PACKAGES = $(call list,.base) \
		 $(COMMON_PACKAGES) \
		 $(MAIN_PACKAGES) \
		 $(call list,$(BASE_LISTS)) \
		 $(call list,$(DISK_LISTS))

MKI_DESTDIR = ALTLinux/RPMS.main
MKI_PACK_RESULTS = data

include $(MKIMAGE_PREFIX)/targets.mk

# TODO: pkg groups
all: debug copy-packages pack-image

debug:
	@echo "IMAGE_PACKAGES: $(IMAGE_PACKAGES)"
