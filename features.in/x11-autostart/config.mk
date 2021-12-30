use/x11-autostart: use/x11
	@$(call add_feature)
ifeq (distro,$(IMAGE_CLASS))
	@$(call add,BASE_PACKAGES,installer-feature-runlevel5-stage3)	###
endif
