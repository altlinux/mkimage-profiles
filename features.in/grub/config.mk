# default is plain text prompt
# NB: might be usbflash-ready hybrid iso

ifeq (,$(filter-out i586 x86_64 ppc64le aarch64,$(ARCH)))

use/grub: sub/stage1 $(ISOHYBRID:%=use/isohybrid)
	@$(call add_feature)
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call try,BOOTVGA,normal)
endif
	@$(call set,RELNAME,ALT ($(IMAGE_NAME)))
	@$(call set,IMAGE_PACKTYPE,boot)
else

use/grub: ; @:

endif

# UI is overwritten
use/grub/ui/%: use/grub
	@$(call set,GRUB_UI,$*)
	@if [ "$*" == gfxboot ]; then \
		$(call add,STAGE1_BRANDING,bootloader); \
	fi

use/grub/%.cfg: use/grub
	@$(call add,GRUB_CFG,$*)


use/grub/timeout/%: use/grub
	@$(call set,GRUB_TIMEOUT,$*)
