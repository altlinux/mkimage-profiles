# default is plain text prompt
# NB: might be usbflash-ready hybrid iso

# on ppc64le, aarch64 syslinux feature is used only to generate config
# (it's converted into grub.cfg later)
ifeq (,$(filter-out i586 x86_64 ppc64le aarch64,$(ARCH)))

use/syslinux: sub/stage1 $(ISOHYBRID:%=use/isohybrid)
	@$(call add_feature)
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call add,STAGE1_PACKAGES,syslinux)
	@$(call try,BOOTVGA,normal)
	@$(call add,SYSLINUX_FILES,/usr/lib/syslinux/pxelinux.0)
endif
	@$(call try,META_SYSTEM_ID,SYSLINUX)
	@$(call set,RELNAME,ALT ($(IMAGE_NAME)))
	@$(call set,IMAGE_PACKTYPE,boot)
else

use/syslinux: ; @:

endif

ifeq (,$(filter-out i586 x86_64,$(ARCH)))
# UI is overwritten
use/syslinux/ui/%: use/syslinux
	@$(call set,SYSLINUX_UI,$*)
	@if [ "$*" == gfxboot ]; then \
		$(call add,STAGE1_PACKAGES,gfxboot); \
		$(call add,STAGE1_BRANDING,bootloader); \
	fi
else
use/syslinux/ui/%: use/syslinux; @:
endif

# modules and config snippets just add up
use/syslinux/%.com use/syslinux/%.c32: use/syslinux
	@$(call add,SYSLINUX_MODULES,$*)

use/syslinux/%.cfg: use/syslinux
	@$(call add,SYSLINUX_CFG,$*)

ifeq (,$(filter-out ppc64le aarch64,$(ARCH)))
use/syslinux/localboot.cfg use/syslinux/removable.cfg use/syslinux/lateboot.cfg use/syslinux/sdab.cfg: use/syslinux; @:
use/syslinux/install-vnc-connect.cfg: use/syslinux/grub-install-vnc-connect.cfg; @:
use/syslinux/install-vnc-listen.cfg: use/syslinux/grub-install-vnc-listen.cfg; @:
endif

use/syslinux/timeout/%: use/syslinux
	@$(call set,SYSLINUX_TIMEOUT,$*)
