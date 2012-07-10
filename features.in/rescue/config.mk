use/rescue: use/stage2 sub/stage2@rescue use/syslinux/sdab.cfg
	@$(call add_feature)
	@$(call add,RESCUE_LISTS, openssh \
		$(call tags,(base || extra) && (rescue || network)))
