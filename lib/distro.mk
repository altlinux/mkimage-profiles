# step 2: build up distribution's configuration

ifeq (,$(MKIMAGE_PROFILES))
$(error this makefile is designed to be included in toplevel one)
endif

ifeq (distro,$(IMAGE_CLASS))
# fundamental targets

distro/.init: profile/bare
	@$(call try,META_PREPARER,mkimage-profiles)
	@$(call try,META_APP_ID,$(IMAGE_NAME))
	@$(call try,META_PUBLISHER,ALT Linux Team)

distro/.boot: distro/.init boot/iso
ifeq (sisyphus,$(BRANCH))
	@$(call try,META_VOL_ID,ALT $(IMAGE_NAME)/$(ARCH))
else
	@$(call try,IMAGE_FLAVOUR,$(subst alt-$(BRANCH)-,,$(IMAGE_NAME)))
	@$(call try,META_VOL_ID,ALT $(BRANCH) $$(IMAGE_FLAVOUR)/$(ARCH))
endif
	@$(call try,META_VOL_SET,ALT)

# NB: the last flavour in KFLAVOURS gets to be the default one;
# the kernel packages regexp evaluation has to take place at build stage
distro/.base: distro/.boot use/kernel
	@$(call try,META_SYSTEM_ID,LINUX)

# this one should not be fundamental as it appears (think armh)
distro/.installer: distro/.base use/bootloader/grub +installer; @:

endif
