# step 2: build up distribution's configuration

ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

ifeq (distro,$(IMAGE_CLASS))
# fundamental targets

distro/.init: profile/bare
	@$(call try,META_PREPARER,mkimage-profiles)
	@$(call try,META_APP_ID,$(IMAGE_NAME))
	@$(call set,META_PUBLISHER,ALT Linux Team)

# NB: the last flavour in KFLAVOURS gets to be the default one;
# the kernel packages regexp evaluation has to take place at build stage
distro/.base: distro/.init use/kernel
	@$(call set,META_SYSTEM_ID,LINUX)
	@$(call set,META_VOL_ID,ALT $(IMAGE_NAME)/$(ARCH))
	@$(call set,META_VOL_SET,ALT)

# this one should not be fundamental as it appears (think armh)
distro/.installer: distro/.base use/bootloader/grub +installer; @:

endif
