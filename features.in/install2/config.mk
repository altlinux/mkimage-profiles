use/install2: use/stage2 sub/stage2/install2
	@$(call add,FEATURES,install2)
	@$(call set,INSTALL2_PACKAGES,installer-distro-$$(INSTALLER)-stage2)
	@$(call add,INSTALL2_PACKAGES,branding-$$(BRANDING)-alterator)
	@$(call add,MAIN_PACKAGES,branding-$$(BRANDING)-release)
	@$(call add,BASE_LISTS,$(call tags,basesystem))
