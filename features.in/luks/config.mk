LUKS_LISTS := $(call tags,security luks)

use/luks:
	@$(call add,THE_LISTS,$(LUKS_LISTS))
	@$(call add,RESCUE_LISTS,$(LUKS_LISTS))
