use/virtualbox/guest:
	@$(call add_feature)
	@$(call add,KMODULES,virtualbox-addition)
	@$(call add,BASE_PACKAGES,virtualbox-guest-additions)
