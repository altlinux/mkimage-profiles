ifeq (,$(filter-out aarch64,$(ARCH)))
use/arm-rpi4: use/uboot use/auto-resize
	@$(call add_feature)
	@$(call set,VM_PARTTABLE,msdos)
	@$(call set,VM_BOOTTYPE,EFI)
	@$(call add,BASE_KMODULES,staging)
	@$(call add,THE_LISTS,uboot)
	@$(call add,THE_PACKAGES,u-boot-tools)
	@$(call add,THE_PACKAGES,firmware-bcm4345)
	@$(call add,DEFAULT_SERVICES_DISABLE,smartd)

use/arm-rpi4/x11: use/arm-rpi4
	@$(call add,THE_PACKAGES,pi-bluetooth)
	@$(call add,DEFAULT_SERVICES_ENABLE,bluetoothd hciuart)
	@$(call add,DEFAULT_SERVICES_DISABLE,systemd-networkd-wait-online)

use/arm-rpi4/kernel: use/arm-rpi4; @:
	@$(call set,RPI_NOUBOOT,yes)
	@$(call add,THE_PACKAGES,rpi4-boot-switch)
	@$(call add,THE_PACKAGES,rpi4-boot-nouboot-filetrigger)
	@$(call add,THE_PACKAGES,rpi4-boot-uboot-filetrigger)
	@$(call xport,RPI_NOUBOOT)
	@$(call set,KFLAVOURS,rpi-def rpi-un)

use/arm-rpi4/full: use/arm-rpi4/kernel use/arm-rpi4/x11; @:

endif
