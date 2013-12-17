use/memtest: use/syslinux
	@$(call add_feature)
	@$(call add,SYSTEM_PACKAGES,memtest86+)
	@$(call add,SYSLINUX_CFG,memtest)

# see also use/efi/memtest86
