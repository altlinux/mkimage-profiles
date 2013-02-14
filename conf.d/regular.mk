# regular build/usage images
ifeq (distro,$(IMAGE_CLASS))

# TODO: use/plymouth/live when luks+plymouth is done, see also #28255
distro/.regular-desktop: distro/.base +live +wireless use/live/ru \
	use/live/install use/live/repo use/live/net-eth use/x11/3d-free \
	use/systemd use/firmware/wireless use/efi/signed use/luks \
	+vmguest use/memtest use/branding use/syslinux/ui/gfxboot
	@$(call add,LIVE_LISTS,$(call tags,base regular))
	@$(call add,LIVE_LISTS,$(call tags,rescue extra))
	@$(call add,LIVE_LISTS,domain-client)
	@$(call add,THE_BRANDING,indexhtml notes alterator bootloader)
	@$(call set,KFLAVOURS,std-def)
	@$(call add,KMODULES,r8168)
	@$(call try,SAVE_PROFILE,yes)

distro/.regular-gtk: distro/.regular-desktop use/x11/lightdm/gtk +plymouth; @:
	@$(call add,THE_BRANDING,graphics)

distro/regular-icewm: distro/.regular-gtk +icewm use/efi/refind
	@$(call add,LIVE_PACKAGES,xxkb mutt)

distro/regular-xfce: distro/.regular-gtk use/x11/xfce; @:
distro/regular-lxde: distro/.regular-gtk use/x11/lxde; @:

distro/regular-mate: distro/.regular-gtk
	@$(call add,LIVE_LISTS,$(call tags,(desktop || mobile) && (mate || nm)))

distro/regular-e17: distro/.regular-gtk use/x11/e17
	@$(call add,LIVE_PACKAGES,xterm xorg-xnest)

distro/regular-cinnamon: distro/.regular-desktop use/x11/cinnamon
	@$(call set,META_VOL_ID,ALT Linux $(IMAGE_NAME)) # see also #28271
	@$(call add,LIVE_PACKAGES,fontconfig-infinality)

distro/regular-gnome3: distro/.regular-desktop use/x11/gnome3; @:

distro/regular-tde: distro/.regular-desktop +tde +plymouth
	@$(call add,LIVE_LISTS,$(call tags,desktop nm))
	@$(call add,LIVE_PACKAGES,kdegames kdeedu)

distro/regular-kde4: distro/.regular-desktop use/x11/kde4 use/x11/kdm4 +plymouth
	@$(call add,LIVE_PACKAGES,kde4-regular)
	@$(call add,LIVE_PACKAGES,plasma-applet-networkmanager)

distro/regular-razorqt: distro/.regular-desktop use/x11/razorqt use/x11/kdm4 \
	+plymouth; @:

endif
