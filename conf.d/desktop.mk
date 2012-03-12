# desktop distributions
ifeq (distro,$(IMAGE_CLASS))

distro/.desktop-base: distro/.installer \
	use/syslinux/ui-vesamenu use/x11/xorg
	@$(call set,INSTALLER,desktop)

distro/.desktop-mini: distro/.desktop-base \
	use/lowmem use/x11/xdm use/power/acpi/button \
	use/cleanup/alterator

distro/icewm: distro/.desktop-mini
	@$(call add,BASE_LISTS,$(call tags,icewm desktop))

distro/tde: distro/.desktop-mini use/x11/kdm
	@$(call add,BASE_LISTS, \
		$(call tags,(base || desktop) && (network || tde)))

distro/ltsp-icewm: distro/icewm use/ltsp/base

distro/ltsp-tde: distro/tde use/ltsp/base

distro/desktop-systemd: distro/icewm use/systemd

endif
