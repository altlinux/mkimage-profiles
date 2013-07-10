# regular build/usage images
ifeq (distro,$(IMAGE_CLASS))

# common ground
distro/.regular-bare: distro/.base +wireless use/efi/signed \
	use/memtest use/stage2/net-eth use/kernel/net
	@$(call try,SAVE_PROFILE,yes)

# graphical target (not enforcing xorg drivers or blobs)
distro/.regular-x11: distro/.regular-bare use/x11/wacom +vmguest \
	use/live/x11 use/live/ru use/live/install use/live/repo use/live/rw \
	use/luks use/branding
	@$(call add,LIVE_LISTS,$(call tags,(base || desktop) && regular))
	@$(call add,LIVE_LISTS,$(call tags,base rescue))

# WM base target
distro/.regular-base: distro/.regular-x11 use/x11/xorg
	@$(call add,LIVE_PACKAGES,installer-feature-desktop-other-fs-stage2)
	@$(call add,THE_BRANDING,indexhtml notes alterator)
	@$(call add,THE_BRANDING,graphics)

# DE base target
# TODO: use/plymouth/live when luks+plymouth is done, see also #28255
distro/.regular-desktop: distro/.regular-base \
	use/syslinux/ui/gfxboot use/firmware/laptop use/efi/refind +systemd
	@$(call add,LIVE_PACKAGES,fuse-exfat)
	@$(call add,LIVE_LISTS,domain-client)
	@$(call add,THE_BRANDING,bootloader)
	@$(call set,KFLAVOURS,std-def)

distro/.regular-gtk: distro/.regular-desktop use/x11/lightdm/gtk +plymouth; @:

distro/regular-icewm: distro/.regular-base use/init/sysv \
	use/x11/lightdm/gtk +icewm
	@$(call add,LIVE_LISTS,$(call tags,regular icewm))
	@$(call set,KFLAVOURS,un-def)

distro/regular-wmaker: distro/.regular-desktop use/x11/lightdm/gtk \
	use/x11/wmaker
	@$(call add,LIVE_PACKAGES,livecd-install-wmaker)
	@$(call add,LIVE_PACKAGES,xxkb)

ifeq (i586,$(ARCH))
distro/regular-gnustep: distro/regular-wmaker use/x11/gnustep +plymouth
	@$(call add,THE_BRANDING,graphics)
else
	$(error $@ is known buggy on non-i586 at the moment)
endif

distro/regular-xfce: distro/.regular-gtk use/x11/xfce +nm; @:

distro/regular-lxde: distro/.regular-gtk use/x11/lxde use/fonts/infinality +nm; @:

distro/regular-xmonad: distro/.regular-gtk use/x11/xmonad
	@$(call add,LIVE_PACKAGES,livecd-regular-xmonad)

distro/regular-mate: distro/.regular-gtk use/x11/mate +nm
	@$(call add,LIVE_LISTS,$(call tags,mobile mate))

distro/regular-e17: distro/.regular-gtk use/x11/e17 use/fonts/infinality
	@$(call add,LIVE_PACKAGES,xterm)

distro/regular-cinnamon: distro/.regular-gtk \
	use/x11/cinnamon use/fonts/infinality
	@$(call set,META_VOL_ID,ALT Linux $(IMAGE_NAME)) # see also #28271

distro/regular-gnome3: distro/.regular-desktop use/x11/gnome3 +plymouth; @:

distro/regular-tde: distro/.regular-desktop +tde +plymouth +nm
	@$(call add,LIVE_PACKAGES,kdegames kdeedu)

distro/regular-kde4: distro/.regular-desktop use/x11/kde4 use/x11/kdm4 \
	use/fonts/zerg +pulse +plymouth
	@$(call add,LIVE_LISTS,$(call tags,regular kde4))

distro/regular-razorqt: distro/.regular-desktop +razorqt +plymouth; @:

distro/regular-sugar: distro/.regular-gtk use/x11/sugar; @:

distro/regular-rescue: distro/.regular-bare use/rescue/rw \
	use/syslinux/ui/menu use/hdt use/efi/refind
	@$(call set,KFLAVOURS,un-def)

distro/regular-server: distro/.regular-bare +installer +sysvinit +power \
	use/install2/fs use/bootloader/lilo use/firmware use/server/mini
	@$(call add,THE_LISTS,$(call tags,(base || server) && regular))
	@$(call set,INSTALLER,desktop)

endif
