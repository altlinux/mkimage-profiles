# stage 4: dive into mkimage

GLOBAL_BUILDDIR ?= $(shell pwd)
LINKPREFIX := mkimage-profiles

include distcfg.mk
include functions.mk
include $(MKIMAGE_PREFIX)/config.mk

# reconstruct instead of passing yet another variable
IMAGE_FILE := $(IMAGE_NAME).$(IMAGE_TYPE)
IMAGE_OUTFILE := $(IMAGE_NAME)-$(DATE)-$(ARCH).$(IMAGE_TYPE)
MKI_PACK_RESULTS = $(IMAGE_PACKTYPE):$(IMAGE_OUTFILE)

# these get opied over as is
COPY_TREE = ./files

# outdir shouldn't be wiped clean before use
CLEANUP_OUTDIR ?=

APTCONF := $(wildcard $(APTCONF))
ifeq (,$(APTCONF))
GLOBAL_HSH_APT_CONFIG = /etc/apt/apt.conf
else
GLOBAL_HSH_APT_CONFIG = $(APTCONF)
endif

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
	echo "** image: $(IMAGE_OUTFILE)" && \
	ln -sf "$(IMAGE_OUTFILE)" "$(IMAGEDIR)/$(IMAGE_FILE)" && \
	ln -sf "$(IMAGE_FILE)" "$(IMAGEDIR)/$(LINKPREFIX).$(IMAGE_TYPE)"; \
	ln -sf "$$OUTPATH" "$(IMAGE_FILE)"; \
	if [ -n "$(GLOBAL_DEBUG)" ]; then \
		cp -a build.log "$$OUTPATH.log"; \
		cp -a distcfg.mk "$$OUTPATH.cfg"; \
	fi

debug:
	@echo "TOPDIR=$(TOPDIR)"
	@echo "ARCH=$(ARCH)"
	@echo "GLOBAL_HSH_APT_CONFIG=$(GLOBAL_HSH_APT_CONFIG)"
