use/hdt: use/syslinux
	@$(call add,STAGE1_PACKAGES,pciids)
	@$(call add,SYSLINUX_MODULES,hdt)
	@$(call add,SYSLINUX_FILES,/usr/share/misc/pci.ids)
