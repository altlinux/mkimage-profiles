LUKS_LISTS := $(call tags,security luks)

use/luks:
	@$(call add_feature)
	@$(call add,BASE_PACKAGES,make-initrd-luks)
	@$(call add,THE_PACKAGES,alterator-luks)
	@$(call add,THE_LISTS,$(LUKS_LISTS))
	@$(call add,RESCUE_LISTS,$(LUKS_LISTS))
