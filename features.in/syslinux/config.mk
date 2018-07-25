# default is plain text prompt
# NB: might be usbflash-ready hybrid iso
use/syslinux: sub/stage1 $(ISOHYBRID:%=use/isohybrid)
	@$(call add_feature)
	@$(call add,STAGE1_PACKAGES,syslinux)
	@$(call try,META_SYSTEM_ID,SYSLINUX)
	@$(call try,BOOTVGA,normal)
	@$(call set,RELNAME,ALT ($(IMAGE_NAME)))
	@$(call set,IMAGE_PACKTYPE,boot)

# UI is overwritten
use/syslinux/ui/%: use/syslinux
	@$(call set,SYSLINUX_UI,$*)
	@if [ "$*" == gfxboot ]; then \
		$(call add,STAGE1_PACKAGES,gfxboot); \
		$(call add,STAGE1_BRANDING,bootloader); \
	fi

# modules and config snippets just add up
use/syslinux/%.com use/syslinux/%.c32: use/syslinux
	@$(call add,SYSLINUX_MODULES,$*)

use/syslinux/%.cfg: use/syslinux
	@$(call add,SYSLINUX_CFG,$*)

use/syslinux/timeout/%: use/syslinux
	@$(call set,SYSLINUX_TIMEOUT,$*)
