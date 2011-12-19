# step 4: build a stage2 subprofile (custom livecd)

# NB: stage2 is not standalone but rather a common base
#     for all livecd images (installer, live, rescue)

ifndef GLOBAL_BUILDDIR
$(error GLOBAL_BUILDDIR not defined)
endif

default: all

include $(GLOBAL_BUILDDIR)/distcfg.mk
include $(GLOBAL_BUILDDIR)/functions.mk
include $(MKIMAGE_PREFIX)/config.mk

# this might have been prepared by ../stage1/scripts.d/03-test-kernel
-include $(GLOBAL_BUILDDIR)/squashcfg.mk

# this should be brought in by corresponding specific stage2 feature
include stage2cfg.mk

# requisite stuff
IMAGE_PACKAGES += $(SYSTEM_PACKAGES)

# here we also try and come up with the stage1 kernel/modules, if any;
# no kernel flavour specified will result in no modules for stage1 vmlinuz
STAGE1_KFLAVOUR ?= $(lastword $(KFLAVOURS))

ifeq (,$(STAGE1_KFLAVOUR))
$(error STAGE1_KFLAVOUR is utterly empty; cannot guess either)
endif

# need kernel modules only (which require corresponding kernel-image);
# these go into work chroot; NB: no vmlinuz there
IMAGE_PACKAGES_REGEXP = $(call kpackages, \
			$(STAGE1_KMODULES) $(STAGE2_KMODULES), \
			$(STAGE1_KFLAVOUR))

include $(MKIMAGE_PREFIX)/targets.mk

# NB: it's a collector variable, add()ing to a GLOBAL_ results in lost hair
GLOBAL_CLEANUP_PACKAGES := $(CLEANUP_PACKAGES)

all: | $(GLOBAL_DEBUG) build-image run-image-scripts pack-image \
	$(GLOBAL_CLEAN_WORKDIR)

# dummy
debug:: ;
