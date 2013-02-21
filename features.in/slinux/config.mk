use/slinux: use/x11/xfce use/x11/gdm2.20
	@$(call add_feature)
	@$(call set,BRANDING,simply-linux)
	@$(call add,THE_BRANDING,menu xfce-settings)
	@$(call add,THE_LISTS,gnome-p2p)
	@$(call add,THE_LISTS,slinux/$(ARCH))
	@$(call add,THE_LISTS,slinux/games)
	@$(call add,THE_LISTS,slinux/graphics)
	@$(call add,THE_LISTS,slinux/live)
	@$(call add,THE_LISTS,slinux/misc)
	@$(call add,THE_LISTS,slinux/misc-dvd)
	@$(call add,THE_LISTS,slinux/multimedia)
	@$(call add,THE_LISTS,slinux/network)
	@$(call add,THE_LISTS,slinux/xfce)
	@$(call add,THE_LISTS,$(call tags,base l10n))
	@$(call set,META_VOL_SET,Simply Linux)

use/slinux/full: use/isohybrid use/slinux use/systemd +wireless \
	use/branding/complete use/x11/drm use/x11/3d-proprietary
	@$(call add,THE_PACKAGES,apt-conf-sisyphus)
