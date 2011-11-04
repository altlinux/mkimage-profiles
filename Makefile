# steps to build a distribution image:
# --- here
# 1. initialize new profile (BUILDDIR) as a copy of image.in/
# 2. configure distro
# 3. copy the needed bits from metaprofile to a new profile
# --- in BUILDDIR
# 4. build subprofiles and subsequently an image

MKIMAGE_PROFILES = $(dir $(lastword $(MAKEFILE_LIST)))

# only process the first target (inter-target cleanup is tricky)
IMAGE_TARGET := $(firstword $(MAKECMDGOALS))#	distro/server-base.iso
IMAGE_CONF   := $(basename $(MAKECMDGOALS))#	distro/server-base
IMAGE_CLASS  := $(dir $(IMAGE_TARGET))#		distro/ (let's fix it)
IMAGE_CLASS  := $(IMAGE_CLASS:%/=%)#		distro
IMAGE_FILE   := $(notdir $(IMAGE_TARGET))#	server-base.iso
IMAGE_NAME   := $(basename $(IMAGE_FILE))#	server-base
IMAGE_TYPE   := $(suffix $(IMAGE_FILE))#	.iso (fix this too)
IMAGE_TYPE   := $(IMAGE_TYPE:.%=%)#		iso

# preferences
-include $(HOME)/.mkimage/profiles.mk

# most of the actual work done elsewhere
include lib/*.mk
include conf.d/*.mk
include features.in/*/config.mk

DISTRO_TARGETS := $(shell sed -n 's,^\(distro/[^:.]\+\):.*$$,\1,p' \
		lib/distro.mk $(wildcard conf.d/*.mk) | sort)
VE_TARGETS := $(shell sed -n 's,^\(ve/[^:.]\+\):.*$$,\1,p' \
		lib/ve.mk $(wildcard conf.d/*.mk) | sort)
DISTROS := $(call addsuffices,$(DISTRO_EXTS),$(DISTRO_TARGETS)) 
VES     := $(call addsuffices,$(VE_EXTS),$(VE_TARGETS))
IMAGES  := $(DISTROS) $(VES)

.PHONY: $(IMAGES) $(DISTRO_TARGETS) $(VE_TARGETS)

help:
	@echo '** available distribution targets:'
	@echo $(DISTROS) | fmt -sw"$$((COLUMNS>>1))" | column -t
	@echo
	@echo '** available virtual environment targets:'
	@echo $(VES) | fmt -sw"$$((COLUMNS>>1))" | column -t

### suboptimal but at least clear, reliable and convenient
all:
	@n=1; sum=$(words $(DISTROS)); \
	for distro in $(DISTROS); do \
		echo "** building $$distro:"; \
		$(MAKE) --no-print-directory \
			ALL=$$n/$$sum \
			BUILDDIR=$(BUILDDIR) \
			$$distro; \
		echo; \
		n=$$(($$n+1)); \
	done

$(IMAGES): debug \
	config/with/$(IMAGE_CONF) \
	config/like/$(IMAGE_CLASS) \
	config/name/$(IMAGE_NAME) \
	config/pack/$(IMAGE_TYPE) \
	build; @:

debug:
ifeq (2,$(DEBUG))
	@$(foreach v,\
		$(filter IMAGE_%,$(sort $(.VARIABLES))),\
		$(warning $v = $($v)))
endif
