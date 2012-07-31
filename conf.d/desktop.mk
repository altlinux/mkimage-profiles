# desktop distributions
ifeq (distro,$(IMAGE_CLASS))

distro/.desktop-base: distro/.installer use/syslinux/ui/vesamenu use/x11/xorg
	@$(call set,INSTALLER,desktop)

distro/.desktop-mini: distro/.desktop-base use/x11/xdm +power; @:

distro/.desktop-network: distro/.desktop-mini +vmguest
	@$(call add,SYSTEM_PACKAGES,fonts-ttf-google-croscore-arimo)
	@$(call add,BASE_LISTS, \
		$(call tags,(base || desktop) && (l10n || network)))

distro/icewm: distro/.desktop-network use/lowmem +icewm; @:
distro/tde: distro/.desktop-mini +tde; @:
distro/ltsp-tde: distro/tde +ltsp; @:
distro/ltsp-icewm: distro/icewm +ltsp; @:

endif
