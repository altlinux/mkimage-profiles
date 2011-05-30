# steps to build a distribution image:
# --- here
# 1. initialize new profile (BUILDDIR) as a copy of image.in/
# 2. configure distro
# 3. copy subprofiles, script hooks, and package lists/groups
#    from metaprofile to new profile (as needed)
# --- in BUILDDIR
# 4. build subprofiles and subsequently image

all help:
	@echo '** available distribution targets:'
	@echo $(DISTROS) | fmt -sw"$$((COLUMNS>>1))" | column -t

# this could have come from environment;
# if not, can be symlinked if r/w, or made anew (NB: immediate assignment)
ifndef BUILDDIR
PREFIX := mkimage-profiles.build
BUILDDIR := $(shell [ -s build ] && realpath build || bin/mktmpdir $(PREFIX))
endif

# most of the actual work done elsewhere
include clean.mk
include distro.mk
include profile.mk
include log.mk
include iso.mk

# we can't use implicit rules for top-level targets, only for prereqs
CONFIGS := $(shell sed -n 's,^distro/\([^:.]\+\):.*$$,\1,p' distro.mk)
DISTROS := $(addsuffix .iso,$(CONFIGS))
ARCH ?= $(shell arch | sed 's/i686/i586/')
DATE = $(shell date +%Y%m%d)

export ARCH BUILDDIR DATE SHELL

# to be passed into distcfg.mk
IMAGEDIR ?= $(shell [ -d "$$HOME/out" -a -w "$$HOME/out" ] \
	&& echo "$$HOME/out" \
	|| echo "$(BUILDDIR)/out" )
IMAGENAME ?= mkimage-profiles-$(ARCH).iso

$(DISTROS): %.iso: | profile/init distro/% boot/isolinux profile/populate iso
	@# TODO: run automated tests (e.g. iso size)
	@OUTNAME="$(@:.iso=)-$(DATE)-$(ARCH).iso"; \
	 OUTPATH="$(IMAGEDIR)/$$OUTNAME"; \
		test -s "$(IMAGEDIR)/$(IMAGENAME)" && \
		mv "$(IMAGEDIR)/$(IMAGENAME)" "$$OUTPATH" && \
		echo "** image: $$OUTPATH" && \
		ln -sf "$$OUTNAME" "$(IMAGEDIR)/$@" && \
		ln -sf "$@" "$(IMAGEDIR)/mkimage-profiles.iso"; \
		if [ -n "$(DEBUG)" ]; then \
			cp -a "$(BUILDLOG)" "$$OUTPATH.log"; \
			cp -a "$(CONFIG)" "$$OUTPATH.cfg"; \
		fi
