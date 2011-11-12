use/systemd:
	@$(call add,FEATURES,systemd)
	@$(call add,COMMON_PACKAGES,systemd systemd-units systemd-sysvinit)
	@$(call add,COMMON_PACKAGES,installer-feature-systemd-stage3)
