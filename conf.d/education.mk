# Education Set

ifeq (distro,$(IMAGE_CLASS))

distro/education-junior: distro/.installer use/slinux/full \
	use/l10n/default/ru_RU +vmguest
	@$(call set,INSTALLER,junior)
	@$(call set,BRANDING,school-junior)
	@$(call set,META_VOL_SET,Education Junior)
	@$(call add,THE_LISTS,education/desktop)

endif
