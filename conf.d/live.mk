# live images
ifeq (distro,$(IMAGE_CLASS))

distro/dos: distro/.init use/dos use/syslinux/ui/menu; @:

distro/rescue: distro/.base use/rescue use/syslinux/ui/menu \
	use/efi/signed use/efi/refind use/efi/shell; @:

distro/syslinux: distro/.init \
	use/syslinux/localboot.cfg use/syslinux/ui/vesamenu use/hdt; @:

distro/.live-base: distro/.base use/live/base use/power/acpi/button; @:
distro/.live-desktop: distro/.base +live use/live/install use/stage2/net-eth \
	use/plymouth/live use/efi; @:
distro/.live-desktop-ru: distro/.live-desktop use/live/ru; @:

distro/.live-kiosk: distro/.base use/live/base use/live/autologin +power \
	use/syslinux/timeout/1 use/cleanup use/stage2/net-eth
	@$(call add,LIVE_PACKAGES,fonts-ttf-dejavu)
	@$(call add,CLEANUP_PACKAGES,'alterator*' 'guile*' 'vim-common')

distro/live-builder-mini: distro/.live-base use/dev/mkimage use/dev \
	use/syslinux/timeout/30
	@$(call set,KFLAVOURS,$(BIGRAM))
	@$(call add,LIVE_LISTS,\
		$(call tags,(base || live) && (server || builder)))
	@$(call add,LIVE_PACKAGES,livecd-qemu-arch strace)
	@$(call add,LIVE_PACKAGES,qemu-user-binfmt_misc)
	@$(call add,LIVE_PACKAGES,zsh sudo)

distro/live-builder: distro/live-builder-mini use/dev/repo
	@$(call add,MAIN_LISTS,$(call tags,live builder))
	@$(call add,MAIN_PACKAGES,syslinux pciids memtest86+ mkisofs)

distro/live-install: distro/.live-base use/live/textinstall; @:
distro/.livecd-install: distro/.live-base use/live/install; @:

distro/live-icewm: distro/.live-desktop use/x11/lightdm/gtk +icewm; @:
distro/live-razorqt: distro/.live-desktop +razorqt; @:
distro/live-tde: distro/.live-desktop-ru use/live/install +tde; @:
distro/live-fvwm: distro/.live-desktop-ru use/x11/lightdm/gtk use/x11/fvwm; @:

distro/live-rescue: distro/live-icewm use/efi
	@$(call add,LIVE_LISTS,$(call tags,rescue && (fs || live || x11)))
	@$(call add,LIVE_LISTS,openssh \
		$(call tags,(base || extra) && (archive || rescue || network)))

# NB: this one doesn't include the browser, needs to be chosen downstream
distro/.live-webkiosk: distro/.live-kiosk use/live/hooks use/live/ru
	@$(call add,LIVE_LISTS,$(call tags,desktop && (live || network)))
	@$(call add,LIVE_PACKAGES,alsa-utils udev-alsa)
	@$(call add,CLEANUP_PACKAGES,'libqt4*' 'qt4*')

distro/live-webkiosk-mini: distro/.live-webkiosk
	@$(call add,LIVE_PACKAGES,livecd-webkiosk-firefox)

# NB: flash/java plugins are predictable security holes
distro/live-webkiosk-flash: distro/live-webkiosk-mini use/plymouth/live +vmguest
	@$(call add,LIVE_PACKAGES,mozilla-plugin-adobe-flash)
	@$(call add,LIVE_PACKAGES,mozilla-plugin-java-1.6.0-sun)

distro/live-webkiosk: distro/live-webkiosk-mini use/live/desktop; @:

distro/live-webkiosk-chromium: distro/.live-webkiosk
	@$(call add,LIVE_PACKAGES,livecd-webkiosk-chromium)

distro/live-flightgear: distro/live-icewm use/live/sound use/x11/3d-proprietary
	@$(call add,LIVE_PACKAGES,FlightGear fgo input-utils)
	@$(call try,HOMEPAGE,http://www.4p8.com/eric.brasseur/flight_simulator_tutorial.html)

distro/live-gnome: distro/.live-desktop-ru use/systemd use/live/nodm use/x11/3d-proprietary
	@$(call add,LIVE_PACKAGES,gnome3-default)

distro/live-cinnamon: distro/.live-desktop-ru use/live/autologin \
	use/x11/cinnamon use/x11/3d-proprietary; @:

distro/live-mate: distro/.live-desktop-ru use/live/nodm use/x11/3d-free
	@$(call add,LIVE_LISTS,openssh $(call tags,(desktop || mobile) && mate))
	@$(call set,KFLAVOURS,un-def)	# the newest one

distro/live-e17: distro/.live-desktop-ru use/live/autologin \
	use/x11/e17 use/x11/gdm2.20; @:

distro/live-gimp: distro/live-icewm use/x11/3d-free use/live/ru
	@$(call add,LIVE_PACKAGES,gimp tintii immix fim)
	@$(call add,LIVE_PACKAGES,cvltonemap darktable geeqie rawstudio ufraw)
	@$(call add,LIVE_PACKAGES,macrofusion python-module-pygtk-libglade)
	@$(call add,LIVE_PACKAGES,qtfm openssh-clients rsync)
	@$(call add,LIVE_PACKAGES,design-graphics-sisyphus2)

distro/live-sugar: distro/.live-desktop-ru use/x11/sugar; @:

endif
