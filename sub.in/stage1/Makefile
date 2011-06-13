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
# FIXME: un-hardwire description
PROPAGATOR_VERSION = mkimage-profiles 2.0
PROPAGATOR_MAR_MODULES = ./modules
PROPAGATOR_INITFS = ./initfs
COPY_TREE = ./files

include $(MKIMAGE_PREFIX)/targets.mk

# here we try and come up with the installer kernel/modules, if any;
# only a single kernel might be needed (INSTALLER_KFLAVOUR sets explicitly);
# kernel image copied from instrumental chroot into .work/syslinux/alt0/

INSTALLER_KFLAVOUR ?= $(lastword $(KFLAVOURS))

# propagator needed iff stage1 kernel installed (not for e.g. syslinux.iso)
ifeq "$(INSTALLER_KFLAVOUR)" ""
build-propagator:
	@echo "** skipping build-propagator target, no kernel installed"
else
CHROOT_PACKAGES_REGEXP := $(call kpackages,$(INSTALLER_KMODULES_REGEXP),$(INSTALLER_KFLAVOUR))
INFO_INSTALLER_KFLAVOUR := $(INSTALLER_KFLAVOUR)
endif

CHROOT_PACKAGES_REGEXP += $(STAGE1_PACKAGES_REGEXP)
CHROOT_PACKAGES = $(STAGE1_PACKAGES) $(COMMON_PACKAGES)

# scripts prepare bootloader configuration, too
all: | debug prepare-workdir copy-tree run-scripts build-propagator \
	copy-$(BOOTLOADER) pack-image

debug:
	@if test -n "$(GLOBAL_VERBOSE)"; then \
		echo "** STAGE1_PACKAGES: $(STAGE1_PACKAGES)"; \
		echo "** STAGE1_PACKAGES_REGEXP: $(STAGE1_PACKAGES_REGEXP)"; \
		echo "** CHROOT_PACKAGES: $(CHROOT_PACKAGES)"; \
		echo "** CHROOT_PACKAGES_REGEXP: $(CHROOT_PACKAGES_REGEXP)"; \
		echo "** BOOTLOADER: $(BOOTLOADER)"; \
	fi
