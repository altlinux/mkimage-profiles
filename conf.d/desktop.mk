# desktop distributions
ifeq (distro,$(IMAGE_CLASS))

distro/.desktop-base: distro/.installer use/syslinux/ui/vesamenu use/x11/xorg
	@$(call set,INSTALLER,desktop)

distro/.desktop-mini: distro/.desktop-base use/x11/xdm +power; @:

distro/.desktop-network: distro/.desktop-mini mixin/desktop-installer; @:

distro/.desktop-extra:
	@$(call add,BASE_LISTS,$(call tags,(archive || base) && (extra)))

distro/icewm: distro/.desktop-network use/lowmem use/install2/fs +icewm; @:
distro/ltsp-tde: distro/tde +ltsp; @:
distro/ltsp-icewm: distro/icewm +ltsp; @:

endif
