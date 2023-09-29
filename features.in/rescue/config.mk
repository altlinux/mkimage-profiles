use/rescue/.base: use/stage2 sub/stage2@rescue
	@$(call add_feature)
	@$(call add,RESCUE_LISTS,sysvinit)
	@$(call add,RESCUE_PACKAGES,startup startup-rescue udev)
	@$(call add,RESCUE_LISTS,openssh)
	@$(call add,RESCUE_LISTS,grub)

use/rescue/base: use/rescue/.base
	@$(call add,RESCUE_PACKAGES,pciutils nfs-utils os-prober)
	@$(call add,RESCUE_LISTS,\
		$(call tags,base && (rescue || network || security || archive)))

use/rescue: use/rescue/.base use/services use/firmware/full +wireless
	@$(call add,DEFAULT_SERVICES_DISABLE,rpcbind)
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call add,RESCUE_PACKAGES,syslinux)
endif
	@$(call add,RESCUE_LISTS,\
		$(call tags,(base || extra || server || misc || fs) \
			&& !x11 && (rescue || comm || network || security || archive)))

use/rescue/rw: use/rescue use/syslinux/rescue_rw.cfg use/grub/rescue_rw.cfg; @:

test/rescue:
	@$(call xport,TEST_RESCUE)

test/rescue/no-x11: test/rescue
	@$(call add,TEST_RESCUE,no-x11)
