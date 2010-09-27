# --- here
# 1. configure distro
# 2. configure subprofiles, prepare package lists/groups and hooks
# --- in BUILDDIR
# 3. build subprofiles and subsequently image

all help:
	@echo '** available distribution targets:'
	@echo $(DISTROS) | fmt -sw65 | column -t

include clean.mk
include distro.mk
include profile.mk
include iso.mk

# this could have come from environment;
# if not, can be symlinked if r/w, or made anew (NB: immediate assignment)
ifndef BUILDDIR
BUILDDIR := $(shell realpath build || bin/mktmpdir mkimage-profiles.build)
endif

ifdef DEBUG
GLOBAL_VERBOSE ?= 1
SHELL += -x
endif

# we can't use implicit rules for top-level targets, only for prereqs
CONFIGS := $(shell sed -n 's,^distro/\([^:.]\+\):.*$$,\1,p' distro.mk)
DISTROS := $(addsuffix .iso,$(CONFIGS))
ARCH ?= $(shell arch | sed 's/i686/i586/')

export ARCH BUILDDIR DEBUG GLOBAL_VERBOSE SHELL

$(DISTROS): %.iso: | profile/init distro/% boot/isolinux profile/populate iso
