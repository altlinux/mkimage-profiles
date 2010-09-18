# 1. configure distro
# 2. configure subprofiles, prepare package lists/groups and hooks
# 3. build subprofiles
# 4. build image

include clean.mk
include distro.mk
include profile.mk
include iso.mk

# this could have come from environment;
# if not, can be symlinked if r/w, or made anew (NB: immediate assignment)
ifndef BUILDDIR
BUILDDIR := $(shell realpath build || bin/mktmpdir mkimage-profiles.build)
endif
export BUILDDIR

ifdef DEBUG
GLOBAL_VERBOSE ?= 1
SHELL += -x
endif

# we can't use implicit rules for top-level targets, only for prereqs
CONFIGS := $(shell sed -n 's,^distro/\([^:]\+\):.*$$,\1,p' distro.mk)
DISTROS := $(addsuffix .iso,$(CONFIGS))

all:
	@echo '** available distribution targets:'
	@echo $(DISTROS) | fmt -sw65 | column -t

$(DISTROS): %.iso: | profile/init distro/% boot/isolinux profile/populate iso
