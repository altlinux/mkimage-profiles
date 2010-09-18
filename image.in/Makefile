include globals.mk
include functions.mk
include $(MKIMAGE_PREFIX)/config.mk
include $(GLOBAL_BUILDDIR)/.config.mk

SUBDIRS = $(SUBPROFILES)

# "main" subprofile needs genbasedir
CHROOT_PACKAGES = apt-utils
###
MKI_PACK_RESULTS = isoboot:mkimage-profiles.iso
COPY_TREE = ./files
BOOT_TYPE = isolinux

include $(MKIMAGE_PREFIX)/targets.mk

all: prep copy-subdirs copy-tree run-scripts pack-image

# FIXME: scripts.d/?
prep: disk-info metadata
	@echo "TOPDIR=$(TOPDIR)"

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
	tar -cvf files/Metadata/pkg-groups.tar \
		-C $(PKGDIR) \
		$$(echo $(call list,.base) $(call list,$(GROUPS)) $(call group,$(GROUPS)) | sed 's,$(PKGDIR)/*,,g')

