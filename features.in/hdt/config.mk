# no "Memory" in hdt's menu, weird
use/hdt: use/memtest
	@$(call add,SYSLINUX_MODULES,hdt)
	@$(call add,SYSLINUX_FILES,/usr/share/pci.ids)

