include functions.mk
include $(GLOBAL_BUILDDIR)/functions.mk
include $(GLOBAL_BUILDDIR)/.config.mk
include $(MKIMAGE_PREFIX)/config.mk

SUBDIRS = $(SUBPROFILES)

# "main" subprofile needs genbasedir
CHROOT_PACKAGES = apt-utils
###
MKI_PACK_RESULTS = isoboot:mkimage-profiles.iso
COPY_TREE = ./files
BOOT_TYPE = isolinux

ifeq "$(wildcard $(APTCONF))" ""
GLOBAL_HSH_APT_CONFIG = /etc/apt/apt.conf
else
GLOBAL_HSH_APT_CONFIG = $(APTCONF)
endif

include $(MKIMAGE_PREFIX)/targets.mk

all: prep copy-subdirs copy-tree run-scripts pack-image

# FIXME: scripts.d/?
prep: debug disk-info metadata

debug:
	@echo "TOPDIR=$(TOPDIR)"
	@echo "ARCH=$(ARCH)"
	@echo "GLOBAL_HSH_APT_CONFIG=$(GLOBAL_HSH_APT_CONFIG)"

disk-info:
	@mkdir -p files/.disk
	@echo "FIXME" >files/.disk/info	### +$(ARCH)
	@type -t git >&/dev/null && ( \
		cd $(TOPDIR) && \
		git show-ref --head --dereference -s -- HEAD 2>/dev/null; \
	) >files/.disk/commit

# see also alterator-pkg (backend3/pkg-install)
# FIXME: if we copy --as-needed, maybe just tar . ?
metadata:
	@mkdir -p files/Metadata
	@rm -f files/Metadata/pkg-groups.tar
	# FIXME: KERNEL_PACKAGES deprecated, this is broken now! -- or not?..
	@echo "DEBUG: image.in/Makefile" >&2
	@echo -e "\n# auto-added in image.in/Makefile\n$(call kpackages)" >> $(call list,.base)
	tar -cvf files/Metadata/pkg-groups.tar \
		-C $(PKGDIR) \
		$$(echo $(call list,.base) $(call list,$(GROUPS)) $(call group,$(GROUPS)) | sed 's,$(PKGDIR)/*,,g')

