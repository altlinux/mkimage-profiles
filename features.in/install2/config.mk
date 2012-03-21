use/install2: use/stage2 sub/stage2/install2 use/cleanup/installer
	@$(call add_feature)
	@$(call set,INSTALL2_PACKAGES,installer-distro-$$(INSTALLER)-stage2)
	@$(call add,INSTALL2_PACKAGES,branding-$$(BRANDING)-alterator)
	@$(call add,BASE_PACKAGES,branding-$$(BRANDING)-release)
	@$(call add,BASE_LISTS,$(call tags,basesystem))

### FR: curl-mini
use/install2/net: use/install2
	@$(call add,INSTALL2_PACKAGES,curl)
