use/hdt: use/syslinux use/memtest
	@$(call add,FEATURES,hdt)
	@$(call add,STAGE1_PACKAGES,pciids)
	@$(call add,SYSLINUX_MODULES,hdt)
