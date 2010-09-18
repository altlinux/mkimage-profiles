# UI is overwritten and _does_ automatically enable the feature...
use/syslinux/ui-%:
	@$(call add,FEATURES,syslinux)
	@$(call set,SYSLINUX_UI,$*)
	@$(call add,STAGE1_PACKAGES,syslinux)
	if [ "$*" == gfxboot ]; then \
		$(call add,STAGE1_PACKAGES,gfxboot); \
		$(call add,STAGE1_PACKAGES,branding-$$(BRANDING)-bootloader); \
	fi

# ...while plain modules...
use/syslinux/%.com use/syslinux/%.c32:
	@$(call add,SYSLINUX_MODULES,$*)

# ...and menu items don't autoenable it (but stack up themselves)
use/syslinux/%.cfg:
	@$(call add,SYSLINUX_CFG,$*)
