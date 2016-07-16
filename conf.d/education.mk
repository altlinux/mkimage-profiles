# Education Set

ifeq (distro,$(IMAGE_CLASS))

distro/education: distro/.installer use/slinux/full \
	use/l10n/default/ru_RU +vmguest
	@$(call set,INSTALLER,junior)
	@$(call set,BRANDING,alt-education)
	@$(call set,META_VOL_SET,ALT Education 8.0)
	@$(call add,THE_LISTS,education/desktop)
	@$(call add,THE_GROUPS,teacher)
	@$(call add,THE_GROUPS,kde5)
	@$(call add,THE_GROUPS,server-apps)

endif
