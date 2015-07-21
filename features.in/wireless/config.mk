+wireless: use/wireless/full; @:

use/wireless:
	@$(call add_feature)
	@$(call add,THE_KMODULES,bcmwl rt3070 rtl8192 staging)
	@$(call add,THE_PACKAGES,wireless-tools rfkill crda iw)

use/wireless/full: use/wireless use/firmware/wireless; @:
	@$(call add,RESCUE_PACKAGES,wireless-tools rfkill crda iw)
