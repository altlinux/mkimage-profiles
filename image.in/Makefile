# stage 4: dive into mkimage

GLOBAL_BUILDDIR ?= $(shell pwd)
CURRENT_LINK := mkimage-profiles
OUT_LINK := out

include distcfg.mk
include functions.mk
include $(MKIMAGE_PREFIX)/config.mk

# reconstruct instead of passing yet another variable
IMAGE_LINK := $(IMAGE_NAME).$(IMAGE_TYPE)
IMAGE_OUTFILE := $(IMAGE_NAME)-$(DATE)-$(ARCH).$(IMAGE_TYPE)
MKI_PACK_RESULTS = $(IMAGE_PACKTYPE):$(IMAGE_OUTFILE)

# these get opied over as is
COPY_TREE = ./files

# outdir shouldn't be wiped clean before use
CLEANUP_OUTDIR ?=

GLOBAL_HSH_APT_CONFIG := $(wildcard $(APTCONF))

# the lib/build-*.mk comes from features.in/build-*/lib
include lib/*.mk
include $(MKIMAGE_PREFIX)/targets.mk

# specified only for the final image (target-specific)
pack-image: OUTDIR = $(IMAGEDIR)
pack-image: $(IMAGEDIR)

$(IMAGEDIR):
	@mkdir -p "$(IMAGEDIR)"

postprocess:
	@OUTPATH="$(IMAGEDIR)/$(IMAGE_OUTFILE)"; \
	echo "** image: $$OUTPATH" >&2 && \
	ln -sf "$(IMAGE_OUTFILE)" "$(IMAGEDIR)/$(IMAGE_LINK)" && \
	ln -sf "$${IMAGEDIR#`pwd`/}" "$(OUT_LINK)"; \
	ln -sf "$(IMAGE_LINK)" $(OUT_LINK)/"$(CURRENT_LINK).$(IMAGE_TYPE)"; \
	if [ -n "$(GLOBAL_DEBUG)" ]; then \
		cp -a build.log "$$OUTPATH.log"; \
		cp -a distcfg.mk "$$OUTPATH.cfg"; \
	fi

debug:
	@echo "TOPDIR=$(TOPDIR)"
	@echo "ARCH=$(ARCH)"
	@echo "GLOBAL_HSH_APT_CONFIG=$(GLOBAL_HSH_APT_CONFIG)"
