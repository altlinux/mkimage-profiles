
ifeq (,$(filter-out aarch64,$(ARCH)))
use/aarch64-rpi4: use/bootloader/uboot
	@$(call add_feature)
	@$(call set,KFLAVOURS,rpi-def rpi-un)
	@$(call add,THE_PACKAGES,u-boot-tools)
	@$(call add,THE_PACKAGES,RPi-audioswitch)
	@$(call add,THE_PACKAGES,rpi4-boot-switch)

endif
