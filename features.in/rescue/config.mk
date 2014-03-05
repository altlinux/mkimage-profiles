use/rescue/.base: use/stage2 sub/stage2@rescue
	@$(call add_feature)
	@$(call add,RESCUE_LISTS,sysvinit)
	@$(call add,RESCUE_PACKAGES,startup startup-rescue udev)
	@$(call add,RESCUE_LISTS,openssh)

use/rescue/base: use/rescue/.base
	@$(call add,RESCUE_PACKAGES,pciutils)
	@$(call add,RESCUE_LISTS,\
		$(call tags,base && (rescue || network || security || archive)))

use/rescue: use/rescue/.base use/syslinux/sdab.cfg \
	use/services use/firmware/full +wireless
	@$(call add,DEFAULT_SERVICES_DISABLE,rpcbind)
	@$(call add,RESCUE_PACKAGES,grub2-pc lilo syslinux)
ifneq (,$(EFI_BOOTLOADER))
	@$(call add,RESCUE_PACKAGES,grub2-efi)
endif
	@$(call add,RESCUE_LISTS,\
		$(call tags,(base || extra || server || backup || misc || fs) \
			&& (rescue || comm || network || security || archive)))

# rw slice, see also use/live/rw (don't use simultaneously)
ifeq (,$(EFI_BOOTLOADER))
use/rescue/rw: use/rescue use/syslinux
	@$(call add,SYSLINUX_CFG,rescue_rw)
else
use/rescue/rw: use/rescue; @:
endif

test/rescue:
	@$(call xport,TEST_RESCUE)

test/rescue/no-x11: test/rescue
	@$(call add,TEST_RESCUE,no-x11)
