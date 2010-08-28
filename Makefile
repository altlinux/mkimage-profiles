# 1. configure distro
# 2. configure subprofiles, prepare package lists
# 3. build subprofiles
# 4. build image

include clean.mk
include distro.mk
include iso.mk

# we can't use implicit rules for top-level targets, only for prereqs
CONFIGS=$(shell sed -n 's,^distro/\([^:]\+\):.*$$,\1,p' distro.mk)
DISTROS=$(addsuffix .iso,$(CONFIGS))

all:
	@echo '** available distribution targets:'
	@echo $(DISTROS) | fmt -sw65 | column -t

$(DISTROS): %.iso: | prep distro/% iso
