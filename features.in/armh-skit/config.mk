ifeq (,$(filter-out armh,$(ARCH)))
use/armh-skit: use/bootloader/uboot use/tty/S0 use/no-sleep
	@$(call add_feature)
	@$(call set,KFLAVOURS,skit)
	@$(call add,THE_PACKAGES,extlinux-fdtdir-cleanup-filetrigger)
	@$(call add,THE_PACKAGES,xorg-drv-fbturbo)

endif
