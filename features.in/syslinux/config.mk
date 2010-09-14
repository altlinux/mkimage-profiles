# UI _does_ automatically enable the feature...
use/syslinux/ui/%:
	$(call set,SYSLINUX_UI,$*)
	$(call add,FEATURES,syslinux)
	$(call add,SYSLINUX_ITEMS,$*)

# ...and menu items don't
use/syslinux/%:
	$(call add,SYSLINUX_ITEMS,$*)
