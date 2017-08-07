# steps to build an image:
# --- here
# 1. initialize new profile (BUILDDIR) as a copy of image.in/
# 2. configure distro
# 3. copy the needed bits from metaprofile to a new profile
# --- in BUILDDIR
# 4. build subprofiles and subsequently an image

# deal with one target at a time
IMAGE_TARGET := $(firstword $(MAKECMDGOALS))#	ve/generic.tar.gz
ifeq (./,$(dir $(IMAGE_TARGET)))#		convenience fallback
IMAGE_TARGET := distro/$(IMAGE_TARGET)#		for omitted "distro/"
IMAGE_GUESS  := 1
else
IMAGE_GUESS  :=
endif
IMAGE_CONF    := $(firstword $(subst ., ,$(IMAGE_TARGET)))# ve/generic
IMAGE_CLASS   := $(firstword $(subst /, ,$(IMAGE_TARGET)))# ve
IMAGE_FILE    := $(lastword  $(subst /, ,$(IMAGE_TARGET)))# generic.tar.gz
IMAGE_NAME    := $(firstword $(subst ., ,$(IMAGE_FILE)))#   generic
IMAGE_TYPE    := $(subst $(IMAGE_NAME).,,$(IMAGE_FILE))#    tar.gz
ifeq ($(IMAGE_NAME),$(IMAGE_TYPE)$(IMAGE_GUESS))
ifneq (help,$(IMAGE_CLASS))
$(warning no image type/extension specified, run make help?)
endif
endif

# readjustable
ifeq (1,$(NUM_TARGETS))
BUILDDIR_PREFIX ?= mkimage-profiles.build
else
BUILDDIR_PREFIX ?= mkimage-profiles.build/$(IMAGE_CONF).$(ARCH)
endif

export MKIMAGE_PROFILES := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

# preferences
-include $(HOME)/.mkimage/profiles.mk

# most of the actual work done elsewhere
include $(sort $(wildcard lib/*.mk))
include conf.d/*.mk
include features.in/*/config.mk

# ensure the outdir is created and globbable
ifdef IMAGEDIR
$(shell mkdir -p $(IMAGEDIR))
IMAGEDIR := $(wildcard $(IMAGEDIR))
endif

# conf.d/*.mk can expose parts conditionally (e.g. DEBUG-only bits)
targets = $(shell \
	  for i in conf.d/*.mk; do \
		make IMAGE_CLASS=$(1) -s -r -p -f $$i 2>/dev/null; \
	  done \
	  | sed -rn 's,^($(1)/[^.:]+):.*,\1,p' \
	  | sort -u)

DISTRO_TARGETS := $(call targets,distro)
VE_TARGETS := $(call targets,ve)
VM_TARGETS := $(call targets,vm)
DISTROS := $(call addsuffices,$(DISTRO_EXTS),$(DISTRO_TARGETS))
VES     := $(call addsuffices,$(VE_EXTS),$(VE_TARGETS))
VMS     := $(call addsuffices,$(VM_EXTS),$(VM_TARGETS))
IMAGES  := $(DISTROS) $(VES) $(VMS)

.PHONY: $(IMAGES) $(DISTRO_TARGETS) $(VE_TARGETS) $(VM_TARGETS)
.PHONY: debug everything help space

# grepping for localized error messages is not trivial
export LC_MESSAGES=C

### duplicate but still needed
everything:
	@n=1; sum=$(words $(DISTROS)); \
	for distro in $(DISTROS); do \
		echo "** building $$distro [$$n/$$sum]:"; \
		$(MAKE) -f main.mk --no-print-directory $$distro; \
		[ "$$n" -lt "$$sum" ] && echo; \
		n=$$(($$n+1)); \
	done

# config/with/ve/generic config/like/ve config/name/generic config/pack/tar.gz
$(IMAGES): debug \
	config/with/$(IMAGE_CONF) \
	config/like/$(IMAGE_CLASS) \
	config/name/$(IMAGE_NAME) \
	config/pack/$(IMAGE_TYPE) \
	build; @:

# convenience shortcut
$(DISTROS:distro/%=%): %: distro/%; @:

debug::
ifeq (2,$(DEBUG))
	@$(foreach v,\
		$(filter IMAGE_%,$(sort $(.VARIABLES))),\
		$(warning $v = $($v)))
endif
