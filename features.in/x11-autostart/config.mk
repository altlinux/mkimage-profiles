use/x11-autostart: use/x11
	@$(call add_feature)
	@$(call add,BASE_PACKAGES,installer-feature-runlevel5-stage3)	###
	@$(call add,DEFAULT_SERVICES_ENABLE,prefdm)
