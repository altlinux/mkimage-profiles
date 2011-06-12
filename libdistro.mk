# low-level part of distro.mk

# request particular image subprofile inclusion
sub/%:
	@$(call add,SUBPROFILES,$(@:sub/%=%))

boot/%: distro/.init
	@$(call set,BOOTLOADER,$*)

# initalize config from scratch, put some sane defaults in
distro/.init:
	@echo "** preparing distro configuration$${DEBUG:+: see $(CONFIG)}" $(SHORTEN)
	@$(call try,MKIMAGE_PREFIX,/usr/share/mkimage)
	@$(call try,GLOBAL_VERBOSE,)
	@$(call try,IMAGEDIR,$(IMAGEDIR))
	@$(call try,IMAGENAME,$(IMAGENAME))

distro/.branding: distro/.init
	@$(call try,BRANDING,altlinux-sisyphus)
	@$(call set,IMAGE_INIT_LIST,+branding-$$(BRANDING)-release)

# NB: the last flavour in KFLAVOURS gets to be the default one;
# the kernel packages regexp evaluation has to take place at build stage
distro/.base: distro/.branding sub/stage1 use/syslinux use/syslinux/localboot.cfg
	@$(call set,IMAGE_INIT_LIST,+branding-$$(BRANDING)-release)
	@$(call set,KFLAVOURS,std-def)

# pick up release manager's config
distro/.rc:
	@if [ -s $(HOME)/.mkimage/profiles.mk ]; then \
		$(call put,-include $(HOME)/.mkimage/profiles.mk); \
	fi
