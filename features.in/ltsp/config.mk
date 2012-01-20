use/ltsp:
	@$(call add,INSTALL2_PACKAGES,installer-feature-ltsp-stage2)
	@$(call add,MAIN_LISTS,ltsp-client ltsp-client.$(ARCH))
