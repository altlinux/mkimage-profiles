# step 4: build the distribution image

# for complex-specified subprofiles like stage2/live,
# take the latter part
SUBDIRS = $(notdir $(SUBPROFILES))

# proxy over the ISO metadata collected; see also genisoimagerc(5)
BOOT_SYSI := $(META_SYSTEM_ID)
BOOT_PUBL := $(META_PUBLISHER)
BOOT_PREP := $(META_PREPARER)
BOOT_APPI := $(META_APP_ID)
BOOT_VOLI := $(META_VOL_ID)
BOOT_VOLS := $(META_VOL_SET)
BOOT_BIBL := $(META_BIBLIO)
BOOT_ABST := $(META_ABSTRACT)

BOOT_TYPE := isolinux

# Metadata/ needed only for installers (and not for e.g. syslinux.iso)
# FIXME: installable live needs it too, don't move to install2 feature
### see also .../pkg.in/lists/Makefile
ifneq (,$(findstring install2,$(FEATURES)))
METADATA = metadata
endif

# see also ../scripts.d/01-isosort; needs mkimage-0.2.2+
MKI_SORTFILE := /tmp/isosort

all: $(GLOBAL_DEBUG) prep copy-subdirs copy-tree run-scripts pack-image \
	postprocess $(GLOBAL_CLEAN_WORKDIR)

prep: $(GLOBAL_DEBUG) dot-disk $(METADATA) imagedir

metadata: dot-base
	@mkdir -p files/Metadata
	@rm -f files/Metadata/pkg-groups.tar
# see also alterator-pkg (backend3/pkg-install); we only tar up what's up to it
	@tar -cvf files/Metadata/pkg-groups.tar -C $(PKGDIR) \
		$$(echo $(call list,$(MAIN_GROUPS) .base) \
			$(call group,$(MAIN_GROUPS)) \
		   | sed 's,$(PKGDIR)/*,,g')

dot-base:
	@p="$(call kpackages,$(THE_KMODULES) $(BASE_KMODULES),$(KFLAVOURS))"; \
	echo -e "\n## added by build-distro.mk\n$$p" >> $(call list,.base); \
	if [ -n "$$DOT_BASE" ]; then \
		echo -e "\n## DOT_BASE\n$$DOT_BASE" >> $(call list,.base); \
	fi

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
