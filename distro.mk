### build up distribution's configuration
CONFIG = $(BUILDDIR)/.config.mk

# ACHTUNG: don"t use ANY quotes ('/") for put() arguments!
#          shell will get confused by ' or args get spammed with "
put = $(and $(1),$(put_body))
define put_body
@printf '%s\n' '$(1)#=- $@' >> "$(CONFIG)";
@# TODO: maybe some more logging/tracing, otherwise inline this
endef

# request particular image subprofile inclusion
sub/%:
	$(call put,SUBPROFILES+=$(@:sub/%=%))

init:
	@echo "** starting distro configuration build process"
	:> $(CONFIG)
	$(call put,KFLAVOUR=std-def)	###
	$(call put,IMAGE_INIT_LIST=+branding-$$(BRANDING)-release)
	#$(call put,STAGE1_PACKAGES=kernel-image-$$(KFLAVOUR))
	$(call put,KERNEL_PACKAGES=kernel-image-$$(KFLAVOUR))

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

use/memtest86:
	$(call put,COMMON_PACKAGES+=memtest86+)
	@# configure syslinux/isolinux as well

use/bootsplash:
	$(call put,COMMON_TAGS+=bootsplash)
