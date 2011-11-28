use/rescue: use/stage2 sub/stage2/rescue
	@$(call add_feature)
	@$(call add,RESCUE_LISTS, \
		$(call tags,(base || extra) && (rescue || network)))
