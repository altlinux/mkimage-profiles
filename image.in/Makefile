# step 4: build image (final stage)
#
# NB: this directory forms the initial BUILDDIR/

ifndef GLOBAL_BUILDDIR
$(error GLOBAL_BUILDDIR not defined)
endif

include functions.mk
include $(GLOBAL_BUILDDIR)/functions.mk
include $(GLOBAL_BUILDDIR)/distcfg.mk
include $(MKIMAGE_PREFIX)/config.mk

SUBDIRS = $(SUBPROFILES)

# "main" subprofile needs genbasedir
CHROOT_PACKAGES = apt-utils
###
MKI_PACK_RESULTS = isoboot:$(IMAGENAME)
COPY_TREE = ./files
BOOT_TYPE = isolinux

# outdir shouldn't be wiped clean before use
CLEANUP_OUTDIR ?=

APTCONF := $(wildcard $(APTCONF))
ifeq "$(APTCONF)" ""
GLOBAL_HSH_APT_CONFIG = /etc/apt/apt.conf
else
GLOBAL_HSH_APT_CONFIG = $(APTCONF)
endif

include $(MKIMAGE_PREFIX)/targets.mk

all: prep copy-subdirs copy-tree run-scripts pack-image

# Metadata/ needed only for installer (and not for e.g. syslinux.iso)
ifeq "$(INSTALLER_KFLAVOUR)$(KFLAVOURS)" ""
metadata:
	@echo "** skipping metadata target, no stage1 kernel installed"
else
metadata: dot-base
	@mkdir -p files/Metadata
	@rm -f files/Metadata/pkg-groups.tar
# see also alterator-pkg (backend3/pkg-install); we only tar up what's up to it
	@tar -cvf files/Metadata/pkg-groups.tar -C $(PKGDIR) \
		$$(echo $(call list,$(GROUPS) .base) \
			$(call group,$(GROUPS)) \
		   | sed 's,$(PKGDIR)/*,,g')
endif

dot-base:
	@echo -e "# auto-added in image.in/Makefile" >> $(call list,.base)
	@echo "$(call kpackages,$(KMODULES),$(KFLAVOURS))" >> $(call list,.base)

prep: $(GLOBAL_DEBUG) dot-disk metadata $(IMAGEDIR)

$(IMAGEDIR):
	mkdir -p "$(IMAGEDIR)"

# specified only for the final image, not for the subparts
pack-image: OUTDIR = $(IMAGEDIR)

debug:
	@echo "TOPDIR=$(TOPDIR)"
	@echo "ARCH=$(ARCH)"
	@echo "GLOBAL_HSH_APT_CONFIG=$(GLOBAL_HSH_APT_CONFIG)"

dot-disk:
	@mkdir -p files/.disk
	@echo "ALT Linux based" >files/.disk/info
	@echo "$(ARCH)" >files/.disk/arch
	@echo "$(DATE)" >files/.disk/date
	@type -t git >&/dev/null && ( \
		cd $(TOPDIR) && \
		git show-ref --head -d -s -- HEAD 2>/dev/null; \
	) >files/.disk/commit
