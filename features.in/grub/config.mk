# default is plain text prompt
# NB: might be usbflash-ready hybrid iso

ifeq (,$(filter-out i586 x86_64 aarch64 riscv64 loongarch64,$(ARCH)))

use/grub: sub/stage1 $(ISOHYBRID:%=use/isohybrid)
	@$(call add_feature)
	@$(call set,RELNAME,ALT ($(IMAGE_NAME)))
	@$(call xport,GRUB_DEFAULT)

# UI is overwritten
use/grub/ui/%: use/grub
ifeq (,$(filter-out i586 x86_64 aarch64 loongarch64,$(ARCH)))
	@$(call set,GRUB_UI,$*)
	@if [ "$*" == gfxboot ]; then \
		$(call add,STAGE1_BRANDING,bootloader); \
		$(call add,STAGE1_PACKAGES,grub-common); \
	fi
else
	@:
endif

use/grub/%.cfg: use/grub
	@$(call add,GRUB_CFG,$*)

use/grub/timeout/%: use/grub
	@$(call set,GRUB_TIMEOUT,$*)
else

use/grub: ; @:
use/grub/ui/% use/grub/%.cfg use/grub/timeout/%: ; @:

endif
