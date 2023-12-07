use/datetime:
	@$(call add_feature)
	@$(call try,TIME_UTC,1)
	@$(call xport,TIME_UTC)
