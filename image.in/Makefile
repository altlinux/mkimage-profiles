# stage 4: dive into mkimage

GLOBAL_BUILDDIR ?= $(shell pwd)
CURRENT_LINK := mkimage-profiles
OUT_LINK := out

# there were mkimage fixes induced by mkimage-profile development
MKI_VER_MINIMAL = 0.1.7
MKI_VER_OPTIMAL = 0.2.0

include distcfg.mk
include functions.mk

ifeq (,$(realpath $(MKIMAGE_PREFIX)/config.mk))
$(error please apt-get install mkimage and have a look at QUICKSTART as well)
endif

include $(MKIMAGE_PREFIX)/config.mk

ifeq (-,$(shell rpmvercmp $(MKI_VERSION) $(MKI_VER_MINIMAL) | tr -d [0-9]))
$(info error: mkimage-$(MKI_VERSION) is too old, please upgrade)
$(error mkimage is too old, $(MKI_VER_MINIMAL) is minimal supported version)
endif
ifeq (-,$(shell rpmvercmp $(MKI_VERSION) $(MKI_VER_OPTIMAL) | tr -d [0-9]))
$(info warning: mkimage-$(MKI_VERSION) is suboptimal, consider upgrading)
$(warning consider upgrading mkimage to $(MKI_VER_OPTIMAL) or better)
endif

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
pack-image: imagedir

copy-tree: $(SAVE_PROFILE:%=save-profile)

save-profile:
	@mkdir -p files/.disk; \
	git archive --prefix=mkimage-profile/ HEAD \
	| gzip -9 > files/.disk/profile.tgz

.PHONY: imagedir postprocess debug

imagedir:
	@mkdir -p "$(IMAGEDIR)"

postprocess: | $(addprefix postprocess-,$(sort $(POSTPROCESS_TARGETS)))
	@OUTPATH="$(IMAGEDIR)/$(IMAGE_OUTFILE)"; \
	OUTSIZE="`ls -lh "$$OUTPATH" | cut -f5 -d' '`"; \
	echo "** image: $$OUTPATH [$$OUTSIZE]" >&2 && \
	ln -sf "$(IMAGE_OUTFILE)" "$(IMAGEDIR)/$(IMAGE_LINK)" && \
	ln -sf "$${IMAGEDIR#`pwd`/}" "$(OUT_LINK)"; \
	ln -sf "$(IMAGE_LINK)" $(OUT_LINK)/"$(CURRENT_LINK).$(IMAGE_TYPE)"; \
	if [ -n "$(GLOBAL_DEBUG)" ]; then \
		cp -a build.log "$$OUTPATH.log"; \
		cp -a distcfg.mk "$$OUTPATH.cfg"; \
	fi

debug:
	@echo "TOPDIR=$(TOPDIR)"
	@echo "IMAGEDIR=$(IMAGEDIR)"
	@echo "ARCH=$(ARCH)"
	@echo "GLOBAL_HSH_APT_CONFIG=$(GLOBAL_HSH_APT_CONFIG)"
