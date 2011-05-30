# step 4: build main subprofile (requisite + optional packages for media)

default: all

include $(GLOBAL_BUILDDIR)/distcfg.mk
include $(GLOBAL_BUILDDIR)/functions.mk
include $(MKIMAGE_PREFIX)/config.mk

CHROOT_PACKAGES = apt-utils rsync

IMAGE_PACKAGES_REGEXP = $(call kpackages)
IMAGE_PACKAGES = $(call map,list,.base $(BASE_LISTS) $(DISK_LISTS) $(GROUPS)) \
		 $(COMMON_PACKAGES) \
		 $(MAIN_PACKAGES)

MKI_DESTDIR = ALTLinux/RPMS.main
MKI_PACK_RESULTS = data

include $(MKIMAGE_PREFIX)/targets.mk

all: debug copy-packages pack-image

debug:
	@echo "IMAGE_PACKAGES: $(IMAGE_PACKAGES)"
