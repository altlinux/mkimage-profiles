# step 4: build the distribution image

# for complex-specified subprofiles like stage2/live,
# take the latter part
SUBDIRS = $(notdir $(SUBPROFILES))

# "main" subprofile needs genbasedir
CHROOT_PACKAGES = apt-utils
BOOT_TYPE = isolinux

# Metadata/ needed only for installers (and not for e.g. syslinux.iso)
# FIXME: installable live needs it too, don't move to install2 feature
ifneq (,$(findstring install2,$(FEATURES)))
METADATA = metadata
endif

all: $(GLOBAL_DEBUG) prep copy-subdirs copy-tree run-scripts pack-image \
	postprocess $(GLOBAL_CLEAN_WORKDIR)

prep: $(GLOBAL_DEBUG) dot-disk $(METADATA) $(IMAGEDIR)

metadata: dot-base
	@mkdir -p files/Metadata
	@rm -f files/Metadata/pkg-groups.tar
# see also alterator-pkg (backend3/pkg-install); we only tar up what's up to it
	@tar -cvf files/Metadata/pkg-groups.tar -C $(PKGDIR) \
		$$(echo $(call list,$(MAIN_GROUPS) .base) \
			$(call group,$(MAIN_GROUPS)) \
		   | sed 's,$(PKGDIR)/*,,g')

dot-base:
	@{ \
		echo -e "\n## added by image.in/Makefile"; \
		echo "$(call kpackages,$(KMODULES),$(KFLAVOURS))"; \
	} >> $(call list,.base)

dot-disk:
	@mkdir -p files/.disk
	@echo "ALT Linux based" >files/.disk/info
	@echo "$(ARCH)" >files/.disk/arch
	@echo "$(DATE)" >files/.disk/date
	@if type -t git >&/dev/null; then \
		( cd $(TOPDIR) && test -d .git && \
		git show-ref --head -ds -- HEAD ||:) \
		>files/.disk/commit 2>/dev/null; \
	fi
