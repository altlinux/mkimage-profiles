use/rescue: use/stage2 sub/stage2/rescue
	@$(call add,FEATURES,rescue)
	@$(call add,RESCUE_LISTS,$(call tags,base && (rescue || network)))
	@$(call add,RESCUE_LISTS,$(call tags,extra network))
