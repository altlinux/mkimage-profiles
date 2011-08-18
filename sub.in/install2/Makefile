# step 4: build install2 subprofile (installer "live" part)

ifndef GLOBAL_BUILDDIR
$(error GLOBAL_BUILDDIR not defined)
endif

default: all

include $(GLOBAL_BUILDDIR)/distcfg.mk
include $(GLOBAL_BUILDDIR)/functions.mk
include $(MKIMAGE_PREFIX)/config.mk

# this might have been prepared by ../stage1/scripts.d/03-test-kernel
-include $(GLOBAL_BUILDDIR)/squashcfg.mk

# here we also try and come up with the installer kernel/modules, if any;
# no kernel flavour specified will result in no modules for stage1 vmlinuz
STAGE1_KFLAVOUR ?= $(lastword $(KFLAVOURS))

ifeq "$(STAGE1_KFLAVOUR)" ""
$(error STAGE1_KFLAVOUR is utterly empty; cannot guess either)
endif

# need kernel modules only (which require corresponding kernel-image);
# these go into work chroot; NB: no vmlinuz there
IMAGE_PACKAGES_REGEXP = $(call kpackages,$(STAGE1_KMODULES),$(STAGE1_KFLAVOUR))
IMAGE_PACKAGES = $(COMMON_PACKAGES) \
		 $(INSTALL2_PACKAGES) \
		 ./packages

MKI_PACK_RESULTS = squash:altinst

include $(MKIMAGE_PREFIX)/targets.mk

all: | $(GLOBAL_DEBUG) build-image run-image-scripts pack-image \
	$(GLOBAL_CLEAN_WORKDIR)

debug:
	@echo "** install2: IMAGE_PACKAGES: $(IMAGE_PACKAGES)"
	@echo "** install2: IMAGE_PACKAGES_REGEXP: $(IMAGE_PACKAGES_REGEXP)"
