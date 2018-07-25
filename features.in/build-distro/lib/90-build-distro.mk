# step 4: build the distribution image

# proxy over the ISO metadata collected; see also genisoimagerc(5)
BOOT_SYSI := $(META_SYSTEM_ID)
BOOT_PUBL := $(META_PUBLISHER)
BOOT_PREP := $(META_PREPARER)
BOOT_APPI := $(META_APP_ID)
BOOT_VOLI := $(shell echo $(META_VOL_ID) | cut -c1-32)
BOOT_VOLS := $(META_VOL_SET)
BOOT_BIBL := $(META_BIBLIO)
BOOT_ABST := $(META_ABSTRACT)
BOOT_COPY := $(META_LICENSE_FILE)

ISODATA_SYSI = $(BOOT_SYSI)
ISODATA_PUBL = $(BOOT_PUBL)
ISODATA_PREP = $(BOOT_PREP)
ISODATA_APPI = $(BOOT_APPI)
ISODATA_VOLI = $(BOOT_VOLI)
ISODATA_VOLS = $(BOOT_VOLS)
ISODATA_BIBL = $(BOOT_BIBL)
ISODATA_ABST = $(BOOT_ABST)
ISODATA_COPY = $(BOOT_COPY)

DATE_F    := $(shell date +%F)

ifeq (isodata,$(IMAGE_PACKTYPE))
BOOT_TYPE :=
else
ifeq (,$(filter-out e2k%,$(ARCH)))
BOOT_TYPE := e2kboot
endif
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
BOOT_TYPE := isolinux
endif
endif

all: | $(GLOBAL_DEBUG) prep copy-subdirs copy-tree run-scripts pack-image \
	postprocess $(GLOBAL_CLEAN_WORKDIR)

prep: | $(GLOBAL_DEBUG) dot-disk $(WHATEVER)

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
