+wireless: use/wireless/full; @:

use/wireless:
	@$(call add_feature)
	@$(call add,THE_KMODULES,bcmwl rt3070 rtl8192 rtl8723de rtl8821ce staging)
	@$(call add,THE_LISTS,tools/wireless)

use/wireless/full: use/wireless use/kernel/wireless; @:
	@$(call add,RESCUE_LISTS,tools/wireless)
