# step 4: build a stage2 subprofile (custom livecd)

# NB: stage2 is not standalone but rather a common base
#     for all livecd images (installer, live, rescue)

ifeq (,$(GLOBAL_BUILDDIR))
$(error GLOBAL_BUILDDIR not defined)
endif

default: all

include $(GLOBAL_BUILDDIR)/distcfg.mk
include $(GLOBAL_BUILDDIR)/functions.mk
include $(MKIMAGE_PREFIX)/config.mk

COPY_TREE = ./files

# this might have been prepared
# by features.in/stage2/stage1/scripts.d/03-test-kernel
-include $(GLOBAL_BUILDDIR)/squashcfg.mk

# this should be brought in by corresponding specific stage2 feature
include stage2cfg.mk

# requisite stuff
IMAGE_PACKAGES += $(SYSTEM_PACKAGES) $(STAGE2_PACKAGES)

# here we try and come up with the installer kernel/modules, if any;
# only for grub allowed multiple kernels, for other a single kernel
# might be needed (STAGE1_KFLAVOURS sets explicitly);
# kernel image copied from instrumental chroot into .work/boot/
ifeq (grubpcboot,$(BOOTLOADER))
STAGE1_KFLAVOURS ?= $(KFLAVOURS)
endif
ifeq (grub-efi,$(EFI_BOOTLOADER))
STAGE1_KFLAVOURS ?= $(KFLAVOURS)
endif
ifeq (ieee1275boot,$(BOOTLOADER))
STAGE1_KFLAVOURS ?= $(KFLAVOURS)
endif
STAGE1_KFLAVOURS ?= $(lastword $(KFLAVOURS))

ifeq (,$(STAGE1_KFLAVOURS))
$(error STAGE1_KFLAVOURS is utterly empty; cannot guess either)
endif

# need kernel modules only (which require corresponding kernel-image);
# these go into work chroot; NB: no vmlinuz there (unless live-install)
IMAGE_PACKAGES_REGEXP += $(call kpackages, \
			 $(STAGE1_KFLAVOURS), \
			 $(STAGE1_KMODULES) $(STAGE1_KMODULES_REGEXP) \
			 $(STAGE2_KMODULES) $(STAGE2_KMODULES_REGEXP))

-include $(sort $(wildcard lib/*.mk))

# see also ./scripts.d/99-elf-stats
ifneq (,$(GLOBAL_SQUASHFS_SORT))
ifeq (tight,$(SQUASHFS))
CHROOT_PACKAGES += file
pack-image: PACK_SQUASHFS_OPTS += -sort /.our/elf.lst
pack-image: CLEANUP_OUTDIR=
endif
endif

GLOBAL_SQUASHFS := $(SQUASHFS)

include $(MKIMAGE_PREFIX)/targets.mk

# NB: it's a collector variable, add()ing to a GLOBAL_ results in lost hair
GLOBAL_CLEANUP_PACKAGES := $(CLEANUP_PACKAGES)

all: |  $(GLOBAL_DEBUG) \
	build-image run-image-patches run-image-scripts copy-tree run-scripts \
	pack-image $(GLOBAL_CLEAN_WORKDIR)

# dummy
debug:: ;
