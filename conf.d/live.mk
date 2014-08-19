# live images
ifeq (distro,$(IMAGE_CLASS))

distro/dos: distro/.init use/dos use/syslinux/ui/menu; @:

distro/rescue: distro/.base use/rescue use/syslinux/ui/menu \
	use/efi/signed use/efi/refind use/efi/shell; @:

distro/syslinux: distro/.init \
	use/syslinux/localboot.cfg use/syslinux/ui/vesamenu use/hdt; @:

distro/.live-base: distro/.base use/live/base use/power/acpi/button; @:
distro/.live-x11: distro/.live-base use/live/x11; @:

distro/.live-desktop: distro/.base +live use/live/install use/stage2/net-eth \
	use/plymouth/live; @:
distro/.live-desktop-ru: distro/.live-desktop use/live/ru; @:

distro/.live-kiosk: distro/.base use/live/base use/live/autologin \
	use/syslinux/timeout/1 use/cleanup use/stage2/net-eth \
	use/fonts/otf/adobe +power
	@$(call add,CLEANUP_PACKAGES,'alterator*' 'guile*' 'vim-common')

distro/live-builder-mini: distro/.live-base use/dev/mkimage use/dev \
	use/stage2/net-eth use/net-eth/dhcp use/syslinux/timeout/30 \
	use/efi/signed
	@$(call set,KFLAVOURS,$(BIGRAM))
	@$(call add,LIVE_LISTS,\
		$(call tags,(base || live) && (server || builder)))
	@$(call add,LIVE_PACKAGES,livecd-qemu-arch strace)
	@$(call add,LIVE_PACKAGES,qemu-user-binfmt_misc)
	@$(call add,LIVE_PACKAGES,zsh sudo)

distro/live-builder: distro/live-builder-mini \
	use/live/rw use/live/repo use/dev/repo
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
distro/.live-webkiosk: distro/.live-kiosk use/live/hooks use/live/ru use/sound
	@$(call add,LIVE_LISTS,$(call tags,live desktop))
	@$(call add,CLEANUP_PACKAGES,'libqt4*' 'qt4*')

distro/live-webkiosk-mini: distro/.live-webkiosk
	@$(call add,LIVE_PACKAGES,livecd-webkiosk-firefox)

# NB: flash/java plugins are predictable security holes
distro/live-webkiosk-flash: distro/live-webkiosk-mini use/plymouth/live \
	use/browser/plugin/flash use/browser/plugin/java +vmguest; @:

distro/live-webkiosk: distro/live-webkiosk-mini use/live/desktop; @:

distro/live-webkiosk-chromium: distro/.live-webkiosk
	@$(call add,LIVE_PACKAGES,livecd-webkiosk-chromium)

distro/.live-3d: distro/.live-x11 use/x11/3d \
	use/x11/lightdm/gtk +icewm +sysvinit
	@$(call add,LIVE_PACKAGES,glxgears glxinfo)

distro/live-glxgears: distro/.live-3d; @:

distro/live-flightgear: distro/.live-kiosk use/x11/3d use/sound \
	use/stage2/net-eth use/net-eth/dhcp use/services +efi +sysvinit
	@$(call set,KFLAVOURS,un-def)
	@$(call add,LIVE_LISTS,$(call tags,xorg misc))
	@$(call add,LIVE_PACKAGES,FlightGear FlightGear-tu154b)
	@$(call add,LIVE_PACKAGES,fgo input-utils livecd-fgfs)
	@$(call add,LIVE_PACKAGES,glxgears glxinfo)
	@$(call add,DEFAULT_SERVICES_DISABLE,rpcbind alteratord messagebus)
	@$(call add,SERVICES_DISABLE,livecd-net-eth)
	@$(call try,HOMEPAGE,http://www.4p8.com/eric.brasseur/flight_simulator_tutorial.html)

distro/live-e17: distro/.live-desktop-ru use/x11/e17 use/x11/lightdm/gtk; @:

distro/live-gimp: distro/live-icewm use/live/ru
	@$(call add,LIVE_PACKAGES,gimp tintii immix fim)
	@$(call add,LIVE_PACKAGES,sane sane-frontends xsane)
	@$(call add,LIVE_PACKAGES,darktable geeqie rawstudio ufraw)
	@$(call add,LIVE_PACKAGES,macrofusion python-module-pygtk-libglade)
	@$(call add,LIVE_PACKAGES,qtfm openssh-clients rsync usbutils)
	@$(call add,LIVE_PACKAGES,design-graphics-sisyphus2)

distro/live-robo: distro/live-icewm +robotics use/live/ru; @:

endif
