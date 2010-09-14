# build up distribution's configuration
CONFIG = $(BUILDDIR)/.config.mk

# source initial feature snippets
-include features.in/*/config.mk

# put(), add(), set(), tags()
#
# package list names are considered relative to pkg/lists/
#
#  $(VAR) will be substituted before writing them to $(CONFIG);
# $$(VAR) will remain unsubstituted util $(CONFIG) is included
#         and their value requested (so the variable referenced
#         can change its value during configuration _before_
#         it's actually used)
#
# tags can do boolean expressions: (tag1 && !(tag2 || tag3))
include functions.mk

# request particular image subprofile inclusion
sub/%:
	$(call add,SUBPROFILES,$(@:sub/%=%))

distro/init:
	@echo "** starting distro configuration build process"
	@:> $(CONFIG)

distro/base: distro/init sub/stage1
	$(call set,KFLAVOUR,std-def)	###
	$(call set,IMAGE_INIT_LIST,+branding-$$(BRANDING)-release)
	$(call set,BRANDING,altlinux-desktop)	###
	$(call set,KERNEL_PACKAGES,kernel-image-$$(KFLAVOUR))

distro/syslinux: distro/base

# NB: our */* are phony targets really, just for namespace
distro/installer: distro/base sub/install2
	@#$(call put,BRANDING=altlinux-sisyphus)	###
	$(call set,BASE_LISTS,base kernel)
	$(call set,INSTALL2_PACKAGES,installer-distro-server-light-stage2)	###

distro/server-base: distro/installer sub/main use/memtest86
	$(call add,BASE_LISTS,server-base kernel-server)

distro/server-light: distro/server-base use/bootsplash
	$(call set,KFLAVOUR,ovz-smp)	# override default
	$(call set,BRANDING,sisyphus-server-light)
	$(call add,DISK_LISTS,kernel-wifi)
	$(call add,BASE_LISTS,$(call tags,base server))

use/bootsplash:
	$(call add,COMMON_TAGS,bootsplash)
