# build up distribution's configuration
CONFIG = $(BUILDDIR)/.config.mk

# source initial feature snippets
-include features.in/*/config.mk

# NB: don"t use ANY quotes ('/") for put() arguments!
# shell will get confused by ' or args get spammed with "
put = $(and $(1),$(put_body))
define put_body
@printf '%s\n' '$(1)#=- $@' >> "$(CONFIG)"
endef

tags = $(shell echo "$(1)" | bin/tags2lists)

# request particular image subprofile inclusion
sub/%:
	$(call put,SUBPROFILES+=$(@:sub/%=%))

# package list names are relative to pkg/lists/
#
#  $(VAR) will be substituted before writing them to $(CONFIG);
# $$(VAR) will remain unsubstituted util $(CONFIG) is included
#         and their value requested (so the variable referenced
#         can change its value during configuration _before_
#         it's actually used)
#
# tags do boolean expressions: (tag1 && !(tag2 || tag3))

init:
	@echo "** starting distro configuration build process"
	:> $(CONFIG)
	$(call put,KFLAVOUR=std-def)	###
	$(call put,IMAGE_INIT_LIST=+branding-$$(BRANDING)-release)
	$(call put,BRANDING=altlinux-desktop)	###
	@#$(call put,STAGE1_PACKAGES=kernel-image-$$(KFLAVOUR))
	$(call put,KERNEL_PACKAGES=kernel-image-$$(KFLAVOUR))

distro/syslinux: init

# NB: our */* are phony targets really, just for namespace
distro/installer: init sub/install2
	@#$(call put,BRANDING=altlinux-sisyphus)	###
	$(call put,BASE_LISTS=base kernel)
	$(call put,INSTALL2_PACKAGES=installer-distro-server-light-stage2)	###

distro/server-base: distro/installer sub/main use/memtest86
	$(call put,BASE_LISTS+=server-base kernel-server)

distro/server-light: distro/server-base use/bootsplash
	$(call put,KFLAVOUR=ovz-smp)	# override default
	$(call put,BRANDING=sisyphus-server-light)
	$(call put,DISK_LISTS+=kernel-wifi)
	$(call put,BASE_LISTS+=$(call tags,base server))

use/bootsplash:
	$(call put,COMMON_TAGS+=bootsplash)
