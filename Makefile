# 1. configure distro
# 2. configure subprofiles, prepare package lists
# 3. build subprofiles
# 4. build image

include clean.mk
include distro.mk
include iso.mk

# this could have come come from environment;
# if not, can be symlinked if r/w, or made anew
ifndef BUILDDIR
BUILDDIR := $(shell realpath build || bin/mktmpdir mkimage-profiles.build)
endif

# we can't use implicit rules for top-level targets, only for prereqs
CONFIGS=$(shell sed -n 's,^distro/\([^:]\+\):.*$$,\1,p' distro.mk)
DISTROS=$(addsuffix .iso,$(CONFIGS))

all:
	@echo '** available distribution targets:'
	@echo $(DISTROS) | fmt -sw65 | column -t

prep:
	@echo "** BUILDDIR: $(BUILDDIR)"
#	ls -ld $(BUILDDIR)
	@rsync -qaH --delete image.in/ "$(BUILDDIR)"/image/
	@rm -f "$(BUILDDIR)"/.config.mk
	@touch "$(BUILDDIR)"/.config.mk
	@mkdir "$(BUILDDIR)"/.mki
	@rm -f build
	@[ -w . ] \
		&& ln -sf "$(BUILDDIR)" build \
		|| echo "** profile directory readonly: skipping symlinks, env only"

$(DISTROS): %.iso: | prep distro/% iso
