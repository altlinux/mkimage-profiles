
ifeq (,$(filter-out armh,$(ARCH)))
use/armh-mcom02: use/uboot use/tty/S0 use/no-sleep use/auto-resize
	@$(call add_feature)
	@$(call set,KFLAVOURS,mcom02)
	@$(call add,THE_PACKAGES,u-boot-mcom02-firmware-tools u-boot-mcom02)
	@$(call add,THE_PACKAGES,extlinux-fdtdir-cleanup-filetrigger)

use/armh-mcom02/x11: use/armh-mcom02
	@$(call add,THE_PACKAGES,xorg-drv-fbturbo)
	@$(call add,UBOOT_BOOTARGS,video=HDMI:1366x768)

use/armh-mcom02/mali: use/armh-mcom02/x11
	@$(call add,THE_KMODULES,mali)
	@$(call add,THE_PACKAGES,libmali-mcom02)
endif
