+wireless: use/wireless; @:

use/wireless:
	@$(call add_feature)
	@$(call add,THE_KMODULES,bcmwl rt3070 staging)
	@$(call add,THE_PACKAGES,wireless-tools rfkill crda iw)
