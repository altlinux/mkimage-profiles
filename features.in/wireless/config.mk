+wireless: use/wireless/full; @:

use/wireless: use/kernel/wireless
	@$(call add_feature)
	@$(call add,THE_LISTS,tools/wireless)

use/wireless/full: use/wireless; @:
	@$(call add,RESCUE_LISTS,tools/wireless)
