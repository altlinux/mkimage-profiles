use/memtest:
	@$(call add,FEATURES,memtest)
	@$(call add,COMMON_PACKAGES,memtest86+)
	@$(call add,SYSLINUX_ITEMS,memtest)
