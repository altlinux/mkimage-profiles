use/slinux: use/x11/xfce
	@$(call add_feature)
	@$(call set,BRANDING,simply-linux)
	@$(call add,THE_BRANDING,menu xfce-settings)
	@$(call set,META_VOL_SET,Simply Linux)

use/slinux/base: use/slinux use/x11/gdm2.20 +pulse
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

use/slinux/full: use/isohybrid use/slinux/base +systemd +wireless \
	use/branding/complete use/x11/3d; @:

use/slinux/arm: use/slinux use/x11/lightdm/gtk
	@$(call add,THE_LISTS,slinux/arm)
