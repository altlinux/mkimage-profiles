use/hdt: use/syslinux use/memtest
	@$(call add,FEATURES,hdt)
	@$(call add,STAGE1_PACKAGES,pciids)
	@$(call add,SYSLINUX_MODULES,hdt)
### moved to scripts.d/02-hdt along with compression
#	@$(call add,SYSLINUX_FILES,/usr/share/misc/pci.ids)
