use/oem: use/services use/branding
	@$(call add_feature)
	@$(call add,DEFAULT_SERVICES_ENABLE,messagebus alteratord setup)
	@$(call add,THE_PACKAGES,alterator-setup alterator-notes)
	@$(call add,THE_BRANDING,alterator notes)
