ifeq (,$(filter-out armh,$(ARCH)))
use/armh-skit: use/uboot use/tty/S0 use/no-sleep use/auto-resize
	@$(call add_feature)
	@$(call set,KFLAVOURS,skit)
	@$(call add,THE_PACKAGES,extlinux-fdtdir-cleanup-filetrigger)
	@$(call add,THE_PACKAGES,xorg-drv-fbturbo)

endif
