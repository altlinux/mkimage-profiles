use/x11-vnc:
	@$(call add,THE_PACKAGES,x11vnc x11vnc-service xorg-drv-dummy)
	@$(call add,DEFAULT_SERVICES_ENABLE,x11vnc)
	@$(call add_feature)
