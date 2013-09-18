# step 4: build the distribution image

# take the latter part for complex-specified subprofiles like stage2@live;
# care to exclude non-directories holding no makefiles like rootfs
SUBDIRS = $(sort $(dir $(wildcard $(addsuffix /Makefile,$(SUBPROFILE_DIRS)))))

# proxy over the ISO metadata collected; see also genisoimagerc(5)
BOOT_SYSI := $(META_SYSTEM_ID)
BOOT_PUBL := $(META_PUBLISHER)
BOOT_PREP := $(META_PREPARER)
BOOT_APPI := $(META_APP_ID)
BOOT_VOLI := $(shell echo $(META_VOL_ID) | cut -c1-32)
BOOT_VOLS := $(META_VOL_SET)
BOOT_BIBL := $(META_BIBLIO)
BOOT_ABST := $(META_ABSTRACT)
DATE_F    := $(shell date +%F)

BOOT_TYPE := isolinux

all: $(GLOBAL_DEBUG) prep copy-subdirs copy-tree run-scripts pack-image \
	postprocess $(GLOBAL_CLEAN_WORKDIR)

prep: $(GLOBAL_DEBUG) dot-disk $(WHATEVER)

# can't use mp-showref which belongs to the metaprofile
dot-disk:
	@mkdir -p files/.disk
	@echo "$(META_VOL_ID) $(DATE_F)" >files/.disk/info
	@echo "$(ARCH)" >files/.disk/arch
	@echo "$(DATE)" >files/.disk/date
	@if type -t git >&/dev/null; then \
		( cd $(TOPDIR) && test -d .git && \
		git show-ref --head -ds -- HEAD ||:) \
		>files/.disk/commit 2>/dev/null; \
	fi
