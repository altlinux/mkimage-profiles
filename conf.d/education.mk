# ALT Education

ifeq (distro,$(IMAGE_CLASS))

distro/education: distro/.installer use/slinux/full \
	use/browser/firefox/esr \
	use/memtest \
	use/l10n/default/ru_RU +vmguest +efi
	@$(call set,INSTALLER,junior)
	@$(call set,BRANDING,alt-education)
	@$(call set,META_VOL_SET,ALT Education 8.0)
	@$(call add,THE_LISTS,education/desktop)
	@$(call add,STAGE2_PACKAGES,xorg-drv-vmware xorg-drv-vmmouse disable-usb-autosuspend)
	@$(call add,THE_GROUPS,education/teacher)
	@$(call add,THE_GROUPS,education/kde5)
	@$(call add,THE_GROUPS,education/server-apps-edu)

endif
