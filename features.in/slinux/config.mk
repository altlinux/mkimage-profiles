use/slinux: use/x11
	@$(call add_feature)
	@$(call set,BRANDING,simply-linux)
	@$(call add,THE_BRANDING,menu xfce-settings system-settings)
	@$(call set,META_PUBLISHER,BaseALT Ltd)
	@$(call set,META_VOL_SET,ALT)

use/slinux/mixin-base: use/slinux use/x11/xorg use/x11/lightdm/gtk +pulse \
	+nm use/x11/gtk/nm +systemd +wireless use/l10n/default/ru_RU \
	use/xdg-user-dirs/deep; @:
	@$(call add,THE_LISTS,gnome-p2p)
	@$(call add,LIVE_LISTS,slinux/games-base)
	@$(call add,LIVE_LISTS,slinux/graphics-base)
	@$(call add,LIVE_LISTS,slinux/multimedia-base)
	@$(call add,LIVE_LISTS,slinux/comm-base)
	@$(call add,THE_LISTS,slinux/misc-base)
	@$(call add,THE_LISTS,slinux/xfce-base)
	@$(call add,THE_LISTS,$(call tags,base l10n))
	@$(call add,THE_KMODULES,staging)

use/slinux/base: use/isohybrid use/luks \
	+plymouth use/memtest +vmguest \
	use/live/x11 use/live/rw use/install2/fonts \
	+efi use/efi/refind use/branding/complete \
	use/slinux/mixin-base; @:
	@$(call set,GLOBAL_LIVE_NO_CLEANUPDB,true)
	@$(call set,KFLAVOURS,std-def)
	@$(call add,LIVE_LISTS,slinux/live)
	@$(call add,THE_PACKAGES,installer-distro-simply-linux-stage3)
	@$(call add,STAGE2_PACKAGES,xorg-conf-libinput-touchpad)
	@$(call add,STAGE2_PACKAGES,chrony)
	@$(call add,STAGE1_MODLISTS,stage2-mmc)

use/slinux/full: use/slinux/base
	@$(call add,MAIN_LISTS,slinux/not-install-full)
	@$(call add,THE_LISTS,slinux/misc-full)
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call add,THE_KMODULES,virtualbox)
	@$(call add,THE_KMODULES,nvidia)
#	@$(call add,THE_KMODULES,fglrx)
	@$(call add,MAIN_KMODULES,bbswitch)
endif

use/slinux/arm: use/slinux use/x11/lightdm/gtk
	@$(call add,THE_LISTS,slinux-arm)
