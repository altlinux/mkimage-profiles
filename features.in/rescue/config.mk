use/rescue: use/stage2 sub/stage2@rescue use/syslinux/sdab.cfg \
	use/firmware/full +wireless
	@$(call add_feature)
	@$(call add,RESCUE_LISTS, openssh \
		$(call tags,(base || extra || server || misc) && \
			(rescue || network || security)))
