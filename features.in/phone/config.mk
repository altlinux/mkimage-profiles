use/phone:
	@$(call add_feature)
	@$(call add,THE_PAKAGES,wallpapers-mobile)

# enables tty on the phone using a hotkey
use/phone/ttyescape: use/phone use/services
ifneq (,$(filter-out riscv64,$(ARCH)))
	@$(call add,THE_PACKAGES,hkdm ttyescape)
endif
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,hkdm)
