# regular build/usage images
ifeq (distro,$(IMAGE_CLASS))

# common ground
distro/.regular-bare: distro/.base +wireless use/efi/signed use/luks \
	use/memtest use/stage2/net-eth use/kernel/net
	@$(call try,SAVE_PROFILE,yes)

# WM base target
distro/.regular-base: distro/.regular-bare +vmguest +live \
	use/live/ru use/live/install use/live/repo use/live/rw \
	use/x11/3d-free use/branding
	@$(call add,LIVE_LISTS,$(call tags,(base || desktop) && regular))
	@$(call add,LIVE_LISTS,$(call tags,rescue extra))
	@$(call add,THE_BRANDING,indexhtml notes alterator)
	@$(call add,THE_BRANDING,graphics)

# DE base target
# TODO: use/plymouth/live when luks+plymouth is done, see also #28255
distro/.regular-desktop: distro/.regular-base \
	use/systemd use/syslinux/ui/gfxboot use/firmware/laptop use/efi/refind
	@$(call add,LIVE_PACKAGES,fuse-exfat)
	@$(call add,LIVE_LISTS,domain-client)
	@$(call add,THE_BRANDING,bootloader)
	@$(call set,KFLAVOURS,std-def)

distro/.regular-gtk: distro/.regular-desktop use/x11/lightdm/gtk +plymouth; @:

distro/regular-icewm: distro/.regular-base use/x11/lightdm/gtk +icewm
	@$(call add,LIVE_LISTS,$(call tags,regular icewm))
	@$(call set,KFLAVOURS,un-def)

distro/regular-wmaker: distro/.regular-desktop use/x11/lightdm/gtk \
	use/x11/wmaker
	@$(call add,LIVE_PACKAGES,livecd-install-wmaker)
	@$(call add,LIVE_PACKAGES,xxkb)

distro/regular-gnustep: distro/regular-wmaker use/x11/gnustep +plymouth
	@$(call add,THE_BRANDING,graphics)

distro/regular-xfce: distro/.regular-gtk use/x11/xfce; @:

distro/regular-lxde: distro/.regular-gtk use/x11/lxde use/fonts/infinality
	@$(call add,LIVE_LISTS,$(call tags,desktop nm))

distro/regular-xmonad: distro/.regular-gtk use/x11/xmonad
	@$(call add,LIVE_PACKAGES,livecd-regular-xmonad)

distro/regular-mate: distro/.regular-gtk
	@$(call add,LIVE_LISTS,$(call tags,(desktop || mobile) && (mate || nm)))

distro/regular-e17: distro/.regular-gtk use/x11/e17
	@$(call add,LIVE_PACKAGES,xterm)

distro/regular-cinnamon: distro/.regular-desktop \
	use/x11/cinnamon use/fonts/infinality
	@$(call set,META_VOL_ID,ALT Linux $(IMAGE_NAME)) # see also #28271

distro/regular-gnome3: distro/.regular-desktop use/x11/gnome3; @:

distro/regular-tde: distro/.regular-desktop +tde +plymouth
	@$(call add,LIVE_LISTS,$(call tags,desktop nm))
	@$(call add,LIVE_PACKAGES,kdegames kdeedu)

distro/regular-kde4: distro/.regular-desktop use/x11/kde4 use/x11/kdm4 \
	use/fonts/zerg +plymouth
	@$(call add,LIVE_LISTS,$(call tags,regular kde4))

distro/regular-razorqt: distro/.regular-desktop +razorqt +plymouth; @:

distro/regular-sugar: distro/.regular-gtk use/x11/sugar; @:

distro/regular-rescue: distro/.regular-bare use/rescue/rw \
	use/syslinux/ui/menu use/hdt use/efi/refind
	@$(call set,KFLAVOURS,un-def)

endif
