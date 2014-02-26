# regular build/usage images
ifeq (distro,$(IMAGE_CLASS))

# common ground
distro/.regular-bare: distro/.base +wireless use/efi/signed \
	use/memtest use/stage2/net-eth use/kernel/net
	@$(call try,SAVE_PROFILE,yes)

# graphical target (not enforcing xorg drivers or blobs)
distro/.regular-x11: distro/.regular-bare use/x11/wacom +vmguest \
	use/live/x11 use/live/install use/live/repo use/live/rw \
	use/luks use/branding
	@$(call add,LIVE_LISTS,$(call tags,(base || desktop) && regular))
	@$(call add,LIVE_LISTS,$(call tags,base rescue))
	@$(call add,LIVE_PACKAGES,gpm livecd-install-apt-cache)
	@$(call add,DEFAULT_SERVICES_ENABLE,gpm)

# common WM live/installer bits
mixin/regular-desktop: use/x11/xorg use/sound use/xdg-user-dirs
	@$(call add,THE_PACKAGES,installer-feature-desktop-other-fs-stage2)
	@$(call add,THE_PACKAGES,alterator-notes)
	@$(call add,THE_BRANDING,alterator graphics indexhtml notes)

# WM base target
distro/.regular-base: distro/.regular-x11 mixin/regular-desktop

# DE base target
# TODO: use/plymouth/live when luks+plymouth is done, see also #28255
distro/.regular-desktop: distro/.regular-base \
	use/syslinux/ui/gfxboot use/firmware/laptop use/efi/refind +systemd
	@$(call add,LIVE_LISTS,domain-client)
	@$(call add,THE_BRANDING,bootloader)
	@$(call set,KFLAVOURS,std-def)

distro/.regular-gtk: distro/.regular-desktop use/x11/lightdm/gtk +plymouth; @:
distro/.regular-sysv: distro/.regular-base +sysvinit; @:
distro/.regular-sysv-gtk: distro/.regular-sysv use/x11/lightdm/gtk; @:

distro/.regular-install: distro/.regular-bare +installer +sysvinit +power \
	use/branding use/bootloader/grub use/luks use/install2/fs
	@$(call add,THE_LISTS,$(call tags,base regular))
	@$(call add,INSTALL2_BRANDING,alterator notes)
	@$(call add,THE_BRANDING,alterator)

distro/.regular-install-x11: distro/.regular-install \
	mixin/regular-desktop +vmguest
	@$(call set,INSTALLER,altlinux-desktop)
	@$(call add,THE_LISTS,$(call tags,regular desktop))

distro/regular-icewm: distro/.regular-sysv-gtk +icewm
	@$(call add,LIVE_LISTS,$(call tags,regular icewm))
	@$(call set,KFLAVOURS,un-def)

distro/regular-wmaker: distro/.regular-sysv-gtk use/x11/wmaker \
	use/syslinux/ui/gfxboot use/efi/refind
	@$(call add,LIVE_PACKAGES,livecd-install-wmaker)
	@$(call add,LIVE_PACKAGES,xxkb)
	@$(call add,MAIN_PACKAGES,wmgtemp wmhdaps wmpomme wmxkbru)

distro/regular-gnustep: distro/regular-wmaker use/x11/gnustep +plymouth
	@$(call add,THE_BRANDING,graphics)

distro/regular-xfce: distro/.regular-gtk use/x11/xfce +nm; @:

distro/regular-lxde: distro/.regular-gtk use/x11/lxde use/fonts/infinality +nm
	@$(call add,LIVE_LISTS,$(call tags,desktop gvfs))

distro/regular-xmonad: distro/.regular-gtk use/x11/xmonad
	@$(call add,LIVE_PACKAGES,livecd-regular-xmonad)

distro/regular-mate: distro/.regular-gtk use/x11/mate +nm
	@$(call add,LIVE_LISTS,$(call tags,mobile mate))

distro/regular-e17: distro/.regular-gtk use/x11/e17 use/fonts/infinality
	@$(call add,LIVE_PACKAGES,xterm)

distro/regular-e18: distro/.regular-gtk use/x11/e18 use/fonts/infinality
	@$(call add,LIVE_PACKAGES,xterm)

distro/regular-cinnamon: distro/.regular-gtk \
	use/x11/cinnamon use/fonts/infinality
	@$(call set,META_VOL_ID,ALT Linux $(IMAGE_NAME)) # see also #28271

distro/regular-gnome3: distro/.regular-desktop use/x11/gnome3 +plymouth; @:

# reusable bits
mixin/regular-tde: use/syslinux/ui/gfxboot +tde +plymouth
	@$(call add,THE_PACKAGES,kdeedu)
	@$(call add,THE_LISTS,openscada)

distro/regular-tde: distro/.regular-desktop mixin/regular-tde +nm; @:

distro/regular-tde-sysv: distro/.regular-sysv mixin/regular-tde \
	use/net-eth/dhcp use/efi/refind; @:

distro/regular-kde4: distro/.regular-desktop use/x11/kde4 use/x11/kdm4 \
	use/fonts/zerg +pulse +plymouth
	@$(call add,LIVE_LISTS,$(call tags,regular kde4))

distro/regular-razorqt: distro/.regular-desktop +razorqt +plymouth; @:

distro/regular-sugar: distro/.regular-gtk use/x11/sugar; @:

distro/regular-rescue: distro/.regular-bare use/rescue/rw \
	use/efi/refind use/efi/shell use/efi/memtest86 \
	use/syslinux/ui/menu use/hdt test/rescue/no-x11
	@$(call set,KFLAVOURS,un-def)
	@$(call add,RESCUE_PACKAGES,gpm)

distro/regular-sysv-tde: distro/.regular-install-x11 \
	mixin/desktop-installer mixin/regular-tde \
	use/branding/complete use/net-eth/dhcp \
	use/efi/refind use/efi/shell use/rescue/base
	@$(call set,KFLAVOURS,led-ws)
	@$(call add,RESCUE_LISTS,$(call tags,rescue misc))
	@$(call add,THE_PACKAGES,alterator-x11 htop k3b pm-utils)
	@$(call add,THE_LISTS,$(call tags,base desktop))

distro/regular-server: distro/.regular-install use/server/mini use/rescue/base
	@$(call add,THE_LISTS,$(call tags,regular server))
	@$(call add,MAIN_PACKAGES,aptitude)
	@$(call set,INSTALLER,altlinux-server)

distro/regular-server-ovz: distro/regular-server \
	use/server/ovz use/server/groups/base; @:

endif
