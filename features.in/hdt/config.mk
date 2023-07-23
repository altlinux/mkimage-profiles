# optimized out use/syslinux due to use/memtest
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
use/hdt: use/syslinux use/memtest
	@$(call add_feature)
	@$(call add,STAGE1_PACKAGES,pciids)
	@$(call add,STAGE1_PACKAGES,dosfstools)
	@$(call add,SYSLINUX_MODULES,hdt)
	@$(call add,GRUB_CFG,hdt_bios)
else
use/hdt: ; @:
endif
