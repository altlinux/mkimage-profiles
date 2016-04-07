# step 4: build main subprofile (requisite + optional packages for media)

ifndef GLOBAL_BUILDDIR
$(error GLOBAL_BUILDDIR not defined)
endif

default: all

include $(GLOBAL_BUILDDIR)/distcfg.mk
include $(GLOBAL_BUILDDIR)/functions.mk
include $(MKIMAGE_PREFIX)/config.mk

CHROOT_PACKAGES = apt-utils rsync

IMAGE_PACKAGES_REGEXP = $(THE_PACKAGES_REGEXP) \
			$(BASE_PACKAGES_REGEXP) \
			$(MAIN_PACKAGES_REGEXP) \
			$(call kpackages, \
			       $(KFLAVOURS), \
			       $(THE_KMODULES) \
			       $(BASE_KMODULES) \
			       $(BASE_KMODULES_REGEXP) \
			       $(MAIN_KMODULES))

IMAGE_PACKAGES = $(call map,list,$(THE_LISTS) $(BASE_LISTS) $(MAIN_LISTS) \
				 $(call groups2lists)) \
		 $(SYSTEM_PACKAGES) $(COMMON_PACKAGES) \
		 $(THE_PACKAGES) $(BASE_PACKAGES) $(MAIN_PACKAGES)

-include $(sort $(wildcard lib/*.mk))

MKI_DESTDIR = ALTLinux/RPMS.main
MKI_PACK_RESULTS = data

include $(MKIMAGE_PREFIX)/targets.mk

all: $(GLOBAL_DEBUG) copy-packages pack-image $(GLOBAL_CLEAN_WORKDIR)

debug:
	@echo "** main: IMAGE_PACKAGES: $(IMAGE_PACKAGES)"
	@echo "** main: IMAGE_PACKAGES_REGEXP: $(IMAGE_PACKAGES_REGEXP)"
