use/virtualbox/guest:
	@$(call add_feature)
	@$(call add,THE_KMODULES,virtualbox-addition)
	@$(call add,THE_PACKAGES,virtualbox-guest-additions)
