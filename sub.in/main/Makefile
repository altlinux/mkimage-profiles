# step 4: build main subprofile (requisite + optional packages for media)

ifndef GLOBAL_BUILDDIR
$(error GLOBAL_BUILDDIR not defined)
endif

default: all

MAIN_SUFFIX := main

include $(GLOBAL_BUILDDIR)/distcfg.mk
include $(GLOBAL_BUILDDIR)/functions.mk
include $(MKIMAGE_PREFIX)/config.mk

CHROOT_PACKAGES = apt-utils rsync

IMAGE_PACKAGES_REGEXP = $(BASE_PACKAGES_REGEXP) \
			$(THE_PACKAGES_REGEXP) \
			$(MAIN_PACKAGES_REGEXP) \
			$(call kpackages, \
			       $(KFLAVOURS), \
			       $(BASE_KMODULES) \
			       $(BASE_KMODULES_REGEXP) \
			       $(THE_KMODULES) \
			       $(MAIN_KMODULES))

IMAGE_PACKAGES = $(SYSTEM_PACKAGES) $(COMMON_PACKAGES) \
		 $(BASE_PACKAGES) $(THE_PACKAGES) $(MAIN_PACKAGES) \
		 $(call map,list,$(BASE_LISTS) $(THE_LISTS) $(MAIN_LISTS) \
				 $(call groups2lists))

-include $(sort $(wildcard lib/*.mk))

MKI_DESTDIR = ALTLinux/RPMS.$(MAIN_SUFFIX)
MKI_PACK_RESULTS = data

include $(MKIMAGE_PREFIX)/targets.mk

all: $(GLOBAL_DEBUG) copy-packages pack-image $(GLOBAL_CLEAN_WORKDIR)

debug:
	@echo "** main: IMAGE_PACKAGES: $(IMAGE_PACKAGES)"
	@echo "** main: IMAGE_PACKAGES_REGEXP: $(IMAGE_PACKAGES_REGEXP)"
