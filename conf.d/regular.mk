# regular build/usage images
ifeq (distro,$(IMAGE_CLASS))

# WM base target
distro/.regular-base: distro/.base +live +wireless use/live/ru \
	use/live/install use/live/repo use/live/net-eth use/x11/3d-free \
	use/efi/signed use/luks +vmguest use/memtest use/branding \
	use/kernel/net
	@$(call add,LIVE_LISTS,$(call tags,base regular))
	@$(call add,LIVE_LISTS,$(call tags,rescue extra))
	@$(call add,THE_BRANDING,indexhtml notes alterator)
	@$(call try,SAVE_PROFILE,yes)

# DE base target
# TODO: use/plymouth/live when luks+plymouth is done, see also #28255
distro/.regular-desktop: distro/.regular-base \
	use/systemd use/syslinux/ui/gfxboot use/firmware/laptop use/efi/refind
	@$(call add,LIVE_LISTS,domain-client)
	@$(call add,THE_BRANDING,bootloader)
	@$(call set,KFLAVOURS,std-def)

distro/.regular-gtk: distro/.regular-desktop use/x11/lightdm/gtk +plymouth; @:
	@$(call add,THE_BRANDING,graphics)

distro/regular-icewm: distro/.regular-base use/x11/lightdm/gtk +icewm
	@$(call add,LIVE_PACKAGES,xxkb mutt)
	@$(call set,KFLAVOURS,un-def)

distro/regular-xfce: distro/.regular-gtk use/x11/xfce; @:
distro/regular-lxde: distro/.regular-gtk use/x11/lxde; @:

distro/regular-mate: distro/.regular-gtk
	@$(call add,LIVE_LISTS,$(call tags,(desktop || mobile) && (mate || nm)))

distro/regular-e17: distro/.regular-gtk use/x11/e17
	@$(call add,LIVE_PACKAGES,xterm)

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

distro/regular-razorqt: distro/.regular-desktop +razorqt +plymouth; @:

endif
