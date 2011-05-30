# step 4: build stage1 subprofile (installer bootstrap)

include $(GLOBAL_BUILDDIR)/distcfg.mk
include $(GLOBAL_BUILDDIR)/functions.mk
include $(MKIMAGE_PREFIX)/config.mk

ifdef BOOTLOADER

MKI_PACK_RESULTS = data
# FIXME: un-hardwire description
PROPAGATOR_VERSION = mkimage-profiles 2.0
PROPAGATOR_MAR_MODULES = ./modules
PROPAGATOR_INITFS = ./initfs
COPY_TREE = ./files

include $(MKIMAGE_PREFIX)/targets.mk

CHROOT_PACKAGES = $(STAGE1_PACKAGES) $(COMMON_PACKAGES)

ifeq "$(KFLAVOURS)" ""
# propagator needed iff stage1 kernel installed (not for e.g. syslinux.iso)
build-propagator:
	@echo "** skipping build-propagator target, no kernel installed"
else
# kernel image copied from instrumental chroot into .work/syslinux/alt0/
# NB: installer only needs a single kernel, no use for multiple ones
ifneq "$(STAGE1_KFLAVOUR)" ""
KFLAVOURS := $(STAGE1_KFLAVOUR)
else
KFLAVOURS := $(lastword $(KFLAVOURS))
endif
ifneq "$(STAGE1_KMODULES_REGEXP)" ""
KMODULES := $(STAGE1_KMODULES_REGEXP)
endif
# set up kernel related part, pass to hooks
CHROOT_PACKAGES_REGEXP := $(call kpackages)
BUILD_PROPAGATOR = build-propagator
INFO_STAGE1_KFLAVOUR := $(KFLAVOURS)
endif

# scripts prepare bootloader configuration, too
all: prepare-workdir copy-tree run-scripts $(BUILD_PROPAGATOR) \
	copy-$(BOOTLOADER) pack-image

debug:
	@if test -n "$(GLOBAL_VERBOSE)"; then \
		echo "** STAGE1_PACKAGES: $(STAGE1_PACKAGES)"; \
		echo "** CHROOT_PACKAGES: $(CHROOT_PACKAGES)"; \
		echo "** CHROOT_PACKAGES_REGEXP: $(CHROOT_PACKAGES_REGEXP)"; \
		echo "** BOOTLOADER: $(BOOTLOADER)"; \
	fi

else
$(error BOOTLOADER undefined)
endif
