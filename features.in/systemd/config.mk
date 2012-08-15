use/systemd:
	@$(call add_feature)
	@$(call add,COMMON_PACKAGES,systemd systemd-units systemd-sysvinit)
	@$(call add,COMMON_PACKAGES,installer-feature-systemd-stage3 chkconfig)
