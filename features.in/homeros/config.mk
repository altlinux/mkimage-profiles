use/homeros: use/control/sudo-su use/services
	@$(call add_feature)
#	@$(call set,BRANDING,simply-linux)
	@$(call add,THE_LISTS,homeros/homeros)
	@$(call add,THE_LISTS,homeros/yasr)
	@$(call add,THE_LISTS,homeros/tools)
	@$(call add,DEFAULT_SERVICES_ENABLE,sshd)
