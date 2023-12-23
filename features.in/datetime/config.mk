use/datetime: ; @:
ifeq (,$(filter-out ve vm,$(IMAGE_CLASS)))
	@$(call add_feature)
	@$(call add,THE_PACKAGES,alterator-datetime-functions)
	@$(call xport,TIME_UTC)
	@$(call xport,TIME_ZONE)
endif
ifeq (distro,$(IMAGE_CLASS))
	@$(call add,LIVE_PACKAGES,livecd-timezone)
	@$(call add,STAGE2_BOOTARGS,utc=$$(TIME_UTC))
	@$(call add,STAGE2_BOOTARGS,tz=$$(TIME_ZONE))
endif
