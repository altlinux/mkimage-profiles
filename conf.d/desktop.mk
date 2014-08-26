# desktop distributions
ifeq (distro,$(IMAGE_CLASS))

distro/.desktop-base: distro/.installer use/syslinux/ui/vesamenu use/x11/xorg
	@$(call set,INSTALLER,desktop)

distro/.desktop-mini: distro/.desktop-base use/x11/xdm +power; @:

mixin/desktop-installer: use/x11-autostart use/sound +net-eth +vmguest
	@$(call add,SYSTEM_PACKAGES,fonts-ttf-google-croscore-arimo)
	@$(call add,BASE_LISTS, \
		$(call tags,(base || desktop) && (l10n || network)))
	@$(call add,INSTALL2_PACKAGES,ntfs-3g)
	@$(call add,BASE_PACKAGES,os-prober)

distro/.desktop-network: distro/.desktop-mini mixin/desktop-installer; @:

distro/.desktop-extra:
	@$(call add,BASE_LISTS,$(call tags,(archive || base) && (extra)))

distro/kde4-lite: distro/.desktop-mini \
	distro/.desktop-network distro/.desktop-extra +kde4-lite
	@$(call set,KFLAVOURS,std-def)

distro/tde: distro/.desktop-network +tde; @:
distro/icewm: distro/.desktop-network use/lowmem use/install2/fs +icewm; @:
distro/ltsp-tde: distro/tde +ltsp; @:
distro/ltsp-icewm: distro/icewm +ltsp; @:

endif
