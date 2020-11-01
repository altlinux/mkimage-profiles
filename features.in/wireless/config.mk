+wireless: use/wireless/full; @:

use/wireless:
	@$(call add_feature)
	@$(call add,THE_KMODULES,bcmwl staging)
	@$(call add,THE_KMODULES,rtl8188fu rtl8192eu rtl8723de rtl8812au)
	@$(call add,THE_KMODULES,rtl8821ce rtl8821cu rtl88x2bu rtl8723bu)
	@$(call add,THE_LISTS,tools/wireless)

use/wireless/full: use/wireless use/kernel/wireless; @:
	@$(call add,RESCUE_LISTS,tools/wireless)
