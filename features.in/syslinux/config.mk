# default is plain text prompt
use/syslinux: sub/stage1
	@$(call add_feature)
	@$(call add,STAGE1_PACKAGES,syslinux)
	@$(call try,META_SYSTEM_ID,SYSLINUX)

# UI is overwritten
use/syslinux/ui-%: use/syslinux
	@$(call set,SYSLINUX_UI,$*)
	@if [ "$*" == gfxboot ]; then \
		$(call add,STAGE1_PACKAGES,gfxboot); \
		$(call add,STAGE1_PACKAGES,branding-$$(BRANDING)-bootloader); \
	fi

# modules and config snippets just add up
use/syslinux/%.com use/syslinux/%.c32: use/syslinux
	@$(call add,SYSLINUX_MODULES,$*)

use/syslinux/%.cfg: use/syslinux
	@$(call add,SYSLINUX_CFG,$*)
