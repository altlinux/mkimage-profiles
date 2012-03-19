# optimized out use/syslinux due to use/memtest
use/hdt: use/memtest
	@$(call add_feature)
	@$(call add,STAGE1_PACKAGES,pciids)
	@$(call add,SYSLINUX_MODULES,hdt)
