
ifeq (,$(filter-out armh,$(ARCH)))
use/armh-mcom02: use/uboot use/tty/S0
	@$(call add_feature)
	@$(call set,KFLAVOURS,mcom02)
	@$(call add,THE_PACKAGES,u-boot-mcom02-firmware-tools u-boot-mcom02)

use/armh-mcom02/x11: use/armh-mcom02
	@$(call add,THE_PACKAGES,xorg-drv-fbturbo)
endif
