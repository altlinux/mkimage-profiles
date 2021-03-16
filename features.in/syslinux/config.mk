# default is plain text prompt
# NB: might be usbflash-ready hybrid iso
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
use/syslinux: sub/stage1 $(ISOHYBRID:%=use/isohybrid)
	@$(call add_feature)
	@$(call add,STAGE1_PACKAGES,syslinux)
	@$(call try,BOOTVGA,normal)
	@$(call add,SYSLINUX_FILES,/usr/lib/syslinux/pxelinux.0)
	@$(call try,META_SYSTEM_ID,SYSLINUX)
	@$(call set,RELNAME,ALT ($(IMAGE_NAME)))
	@$(call xport,SYSLINUX_DEFAULT)
else
use/syslinux: ; @:
endif

# UI is overwritten
use/syslinux/ui/%: use/syslinux
	@$(call set,SYSLINUX_UI,$*)
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@if [ "$*" == gfxboot ]; then \
		$(call add,STAGE1_PACKAGES,gfxboot); \
		$(call add,STAGE1_BRANDING,bootloader); \
	fi
endif

# modules and config snippets just add up
use/syslinux/%.com use/syslinux/%.c32: use/syslinux
	@$(call add,SYSLINUX_MODULES,$*)

use/syslinux/%.cfg: use/syslinux
	@$(call add,SYSLINUX_CFG,$*)

use/syslinux/timeout/%: use/syslinux
	@$(call set,SYSLINUX_TIMEOUT,$*)
