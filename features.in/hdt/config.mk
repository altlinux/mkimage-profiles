use/hdt: use/syslinux
	@$(call add,SYSLINUX_MODULES,hdt)
# might be /usr/share/pci.ids if usig hwdatabase
	@$(call add,SYSLINUX_FILES,/usr/share/misc/pci.ids)

