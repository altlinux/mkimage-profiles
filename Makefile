# steps to build a distribution image:
# --- here
# 1. initialize new profile (BUILDDIR) as a copy of image.in/
# 2. configure distro
# 3. copy subprofiles, package lists/groups and script hooks
#    from metaprofile to new profile (as needed)
# --- in BUILDDIR
# 4. build subprofiles and subsequently image

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
PREFIX := mkimage-profiles.build
BUILDDIR := $(shell [ -s build ] && realpath build || bin/mktmpdir $(PREFIX))
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
