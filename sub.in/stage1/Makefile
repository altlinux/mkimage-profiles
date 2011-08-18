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

MKI_PACK_RESULTS = data
PROPAGATOR_VERSION = ALT Linux
PROPAGATOR_MAR_MODULES = ./modules
PROPAGATOR_INITFS = ./initfs
COPY_TREE = ./files

include $(MKIMAGE_PREFIX)/targets.mk

# here we try and come up with the installer kernel/modules, if any;
# only a single kernel might be needed (STAGE1_KFLAVOUR sets explicitly);
# kernel image copied from instrumental chroot into .work/syslinux/alt0/

STAGE1_KFLAVOUR ?= $(lastword $(KFLAVOURS))

# propagator needed iff stage1 kernel installed (not for e.g. syslinux.iso)
ifeq "$(STAGE1_KFLAVOUR)" ""
build-propagator:
	@echo "** skipping build-propagator target, no kernel installed"
else
CHROOT_PACKAGES_REGEXP := $(call kpackages,$(STAGE1_KMODULES_REGEXP),$(STAGE1_KFLAVOUR))
INFO_STAGE1_KFLAVOUR := $(STAGE1_KFLAVOUR)
endif

CHROOT_PACKAGES_REGEXP += $(STAGE1_PACKAGES_REGEXP)
CHROOT_PACKAGES = $(STAGE1_PACKAGES) $(COMMON_PACKAGES)

# scripts prepare bootloader configuration, too
# NB: we pass tested squashfs options for ../install2/Makefile
all: | debug prepare-workdir copy-tree run-scripts build-propagator \
	copy-$(BOOTLOADER) pack-image $(GLOBAL_CLEAN_WORKDIR)
	@cp $(OUTDIR)/squashcfg.mk $(GLOBAL_BUILDDIR)/

debug:
	@if test -n "$(GLOBAL_VERBOSE)"; then \
		echo "** STAGE1_PACKAGES: $(STAGE1_PACKAGES)"; \
		echo "** STAGE1_PACKAGES_REGEXP: $(STAGE1_PACKAGES_REGEXP)"; \
		echo "** CHROOT_PACKAGES: $(CHROOT_PACKAGES)"; \
		echo "** CHROOT_PACKAGES_REGEXP: $(CHROOT_PACKAGES_REGEXP)"; \
		echo "** BOOTLOADER: $(BOOTLOADER)"; \
	fi
