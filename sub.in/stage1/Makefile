# step 4: build stage1 subprofile (installer bootstrap)

ifndef GLOBAL_BUILDDIR
$(error GLOBAL_BUILDDIR not defined)
endif

include $(GLOBAL_BUILDDIR)/distcfg.mk
include $(GLOBAL_BUILDDIR)/functions.mk
include $(MKIMAGE_PREFIX)/config.mk

ifndef BOOTLOADER
$(error BOOTLOADER not defined)
endif
GLOBAL_BOOTLOADER := $(BOOTLOADER)

MKI_PACK_RESULTS = data
COPY_TREE = ./files

include $(MKIMAGE_PREFIX)/targets.mk

# here we try and come up with the installer kernel/modules, if any;
# only a single kernel might be needed (STAGE1_KFLAVOUR sets explicitly);
# kernel image copied from instrumental chroot into .work/syslinux/alt0/

STAGE1_KFLAVOUR ?= $(lastword $(KFLAVOURS))

# propagator needed iff stage1 kernel installed (not for e.g. syslinux.iso)
ifneq "$(STAGE1_KFLAVOUR)" ""
GLOBAL_STAGE1_KFLAVOUR := $(STAGE1_KFLAVOUR)
CHROOT_PACKAGES_REGEXP := $(call kpackages, \
	$(STAGE1_KFLAVOUR),$(STAGE1_KMODULES_REGEXP))
ifneq "$(findstring stage2,$(SUBPROFILES))" ""	### assumes stage2 ~ propagator
PROPAGATOR_VERSION = ALT
PROPAGATOR_MAR_MODULES = ./modules
PROPAGATOR_INITFS = ./initfs
BUILD_PROPAGATOR = prepare-modules build-propagator
endif
endif

CHROOT_PACKAGES_REGEXP += $(STAGE1_PACKAGES_REGEXP)
CHROOT_PACKAGES = $(STAGE1_PACKAGES) $(SYSTEM_PACKAGES)

# pass for use/stage2
GLOBAL_SQUASHFS := $(SQUASHFS)

-include $(sort $(wildcard lib/*.mk))

prepare-modules:
	@echo $(foreach V,$(STAGE1_MODLISTS),$(wildcard modules.d/??-$(V))) \
	| xargs -r -- cat >> $(PROPAGATOR_MAR_MODULES)

# scripts prepare bootloader configuration, too
# NB: we pass tested squashfs options for sub.in/stage2/Makefile to include
all: | debug prepare-workdir copy-tree run-scripts $(BUILD_PROPAGATOR) \
	copy-$(BOOTLOADER) $(COPY_SQUASHCFG) pack-image $(GLOBAL_CLEAN_WORKDIR)
	@if [ -s $(OUTDIR)/squashcfg.mk ]; then \
		cp $(OUTDIR)/squashcfg.mk $(GLOBAL_BUILDDIR)/; \
	fi

debug:
	@if [ -n "$(GLOBAL_VERBOSE)" ]; then \
		echo "** BRANDING: $(BRANDING)"; \
		echo "** IMAGE_INIT_LIST: $(IMAGE_INIT_LIST)"; \
		echo "** STAGE1_PACKAGES: $(STAGE1_PACKAGES)"; \
		echo "** STAGE1_PACKAGES_REGEXP: $(STAGE1_PACKAGES_REGEXP)"; \
		echo "** CHROOT_PACKAGES: $(CHROOT_PACKAGES)"; \
		echo "** CHROOT_PACKAGES_REGEXP: $(CHROOT_PACKAGES_REGEXP)"; \
		echo "** BOOTLOADER: $(BOOTLOADER)"; \
	fi
