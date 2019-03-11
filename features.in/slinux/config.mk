use/slinux: use/x11
	@$(call add_feature)
	@$(call set,BRANDING,simply-linux)
	@$(call add,THE_BRANDING,menu xfce-settings system-settings)
	@$(call set,META_PUBLISHER,BaseALT Ltd)
	@$(call set,META_APP_ID,$(DISTRO_VERSION)/$(ARCH))

use/slinux/base: use/isohybrid use/slinux use/x11/xorg use/x11/lightdm/gtk +pulse use/luks \
	+plymouth +nm use/x11/gtk/nm use/memtest +systemd +wireless +vmguest use/l10n/default/ru_RU \
	use/live/x11 use/live/rw use/xdg-user-dirs/deep use/install2/fonts \
	+efi use/efi/refind use/branding/complete; @:
	@$(call set,GLOBAL_LIVE_NO_CLEANUPDB,true)
	@$(call set,KFLAVOURS,std-def)
	@$(call add,THE_LISTS,gnome-p2p)
	@$(call add,LIVE_LISTS,slinux/games-base)
	@$(call add,LIVE_LISTS,slinux/graphics-base)
	@$(call add,LIVE_LISTS,slinux/multimedia-base)
	@$(call add,LIVE_LISTS,slinux/network-base)
	@$(call add,LIVE_LISTS,slinux/live)
	@$(call add,THE_LISTS,slinux/misc-base)
	@$(call add,THE_LISTS,slinux/xfce-base)
	@$(call add,THE_LISTS,$(call tags,base l10n))
	@$(call add,STAGE2_PACKAGES,xorg-conf-libinput-touchpad)
	@$(call add,THE_KMODULES,staging)
	@$(call add,STAGE1_MODLISTS,stage2-mmc)

use/slinux/full: use/slinux/base
	@$(call add,MAIN_LISTS,slinux/not-install-full)
	@$(call add,THE_LISTS,slinux/misc-full)
	@$(call add,THE_KMODULES,virtualbox)
	@$(call add,THE_KMODULES,nvidia)
#	@$(call add,THE_KMODULES,nvidia fglrx)
	@$(call add,MAIN_KMODULES,bbswitch)

use/slinux/arm: use/slinux use/x11/lightdm/gtk
	@$(call add,THE_LISTS,slinux-arm)
