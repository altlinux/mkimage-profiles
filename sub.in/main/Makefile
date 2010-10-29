# installation package base (requisite + optional)

default: all

include $(GLOBAL_BUILDDIR)/.config.mk
include $(GLOBAL_BUILDDIR)/functions.mk
include $(MKIMAGE_PREFIX)/config.mk

CHROOT_PACKAGES = apt-utils rsync
PACKAGES_EXPAND_METHOD=regexp

# FIXME: hardwired
#IMAGE_PACKAGES_REGEXP = "$(KERNEL_PACKAGES_REGEXP)"
# NB: due to #24669, IMAGE_PACKAGES_REGEXP does need quoting here
IMAGE_PACKAGES_REGEXP = "$(call kpackages)"
#IMAGE_PACKAGES_REGEXP = $(call kimage) $(call kmodules)
#IMAGE_PACKAGES_REGEXP = ^kernel-image-(std-def|el-smp)$$ ^kernel-modules-(ipset|kvm|ndiswrapper|pf_ring|xtables-addons)-(el-smp|ovz-smp)$$
# TODO: map() list() onto these
IMAGE_PACKAGES = $(call list,.base) \
		 $(COMMON_PACKAGES) \
		 $(MAIN_PACKAGES) \
		 $(call list,$(BASE_LISTS)) \
		 $(call list,$(DISK_LISTS)) \
		 $(call list,$(GROUPS))

MKI_DESTDIR = ALTLinux/RPMS.main
MKI_PACK_RESULTS = data

include $(MKIMAGE_PREFIX)/targets.mk

all: debug copy-packages pack-image

debug:
	@echo "IMAGE_PACKAGES: $(IMAGE_PACKAGES)"
