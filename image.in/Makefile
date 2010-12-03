# step 4: build image (final stage)
#
# NB: this metaprofile directory forms the initial BUILDDIR/

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
prep: debug dot-disk metadata

debug:
ifdef DEBUG
	@echo "TOPDIR=$(TOPDIR)"
	@echo "ARCH=$(ARCH)"
	@echo "GLOBAL_HSH_APT_CONFIG=$(GLOBAL_HSH_APT_CONFIG)"
endif

dot-disk:
	@mkdir -p files/.disk
	@echo "ALT Linux based" >files/.disk/info
	@echo "$(ARCH)" >files/.disk/arch
	@type -t git >&/dev/null && ( \
		cd $(TOPDIR) && \
		git show-ref --head --dereference -s -- HEAD 2>/dev/null; \
	) >files/.disk/commit

# see also alterator-pkg (backend3/pkg-install)
# FIXME: if we copy --as-needed, maybe just tar . ?
metadata:
	@mkdir -p files/Metadata
	@rm -f files/Metadata/pkg-groups.tar
	@echo -e "\n# auto-added in image.in/Makefile\n$(call kpackages)" >> $(call list,.base)
	@echo "branding-$(BRANDING)-release" >> $(call list,.base)
	@tar -cvf files/Metadata/pkg-groups.tar \
		-C $(PKGDIR) \
		$$(echo $(call list,.base) $(call list,$(GROUPS)) $(call group,$(GROUPS)) | sed 's,$(PKGDIR)/*,,g')
