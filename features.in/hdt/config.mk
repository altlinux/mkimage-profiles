# no "Memory" in hdt's menu, weird
use/hdt: use/memtest
	$(call add,SYSLINUX_ITEMS,hdt)
	@# ITEMS iterator will happily omit a missing file, so...
	$(call add,SYSLINUX_FILES,/usr/lib/syslinux/hdt.c32)
	@# TODO: modules.pcimap (optional); maybe gzip
	$(call add,SYSLINUX_FILES,/usr/share/pci.ids)

