# live images
ifeq (distro,$(IMAGE_CLASS))

distro/dos: distro/.init use/dos use/syslinux/ui/menu; @:
distro/rescue: distro/.base use/rescue use/syslinux/ui/menu; @:

distro/.live-base: distro/.base use/live/base use/power/acpi/button; @:
distro/.live-desktop: distro/.base +live use/plymouth/live; @:

distro/.live-kiosk: distro/.base use/live/base use/live/autologin \
	use/syslinux/timeout/1 use/cleanup +power
	@$(call add,LIVE_PACKAGES,fonts-ttf-dejavu)
	@$(call add,CLEANUP_PACKAGES,'alterator*' 'guile*' 'vim-common')

distro/live-builder: pkgs := livecd-tmpfs livecd-online-repo mkimage-profiles
distro/live-builder: distro/.live-base use/dev/mkimage use/dev/repo \
	use/syslinux/timeout/30
	@$(call set,KFLAVOURS,$(BIGRAM))
	@$(call add,LIVE_LISTS,$(call tags,base && (server || builder)))
	@$(call add,LIVE_PACKAGES,livecd-qemu-arch strace)
	@$(call add,LIVE_PACKAGES,qemu-user-binfmt_misc)
	@$(call add,LIVE_PACKAGES,zsh sudo)
	@$(call add,LIVE_PACKAGES,$(pkgs))
	@$(call add,MAIN_PACKAGES,$(pkgs))
	@$(call add,MAIN_PACKAGES,syslinux pciids memtest86+ mkisofs)

distro/live-install: distro/.live-base use/live/textinstall; @:
distro/.livecd-install: distro/.live-base use/live/install; @:

distro/live-icewm: distro/.live-desktop use/live/autologin +icewm; @:
distro/live-razorqt: distro/.live-desktop use/live/autologin +razorqt; @:
distro/live-tde: distro/.live-desktop use/live/ru use/live/install +tde; @:

distro/live-rescue: distro/live-icewm
	@$(call add,LIVE_LISTS,$(call tags,rescue && (fs || live || x11)))
	@$(call add,LIVE_LISTS,openssh \
		$(call tags,(base || extra) && (archive || rescue || network)))

distro/live-webkiosk-mini: distro/.live-kiosk use/live/hooks use/live/ru
	@$(call add,LIVE_LISTS,$(call tags,desktop && (live || network)))
	@$(call add,LIVE_PACKAGES,livecd-webkiosk)
	@$(call add,CLEANUP_PACKAGES,'libqt4*' 'qt4*')

# NB: flash/java plugins are predictable security holes
distro/live-webkiosk-flash: distro/live-webkiosk-mini use/plymouth/live +vmguest
	@$(call add,LIVE_PACKAGES,mozilla-plugin-adobe-flash)
	@$(call add,LIVE_PACKAGES,mozilla-plugin-java-1.6.0-sun)
	@$(call add,LIVE_PACKAGES,alsa-utils udev-alsa)

distro/live-webkiosk: distro/live-webkiosk-mini use/live/desktop; @:

distro/live-flightgear: distro/live-icewm use/live/sound use/x11/3d-proprietary
	@$(call add,LIVE_PACKAGES,FlightGear fgo input-utils)
	@$(call try,HOMEPAGE,http://www.4p8.com/eric.brasseur/flight_simulator_tutorial.html)

distro/live-cinnamon: distro/.live-desktop use/live/autologin use/live/ru \
	use/x11/cinnamon use/x11/3d-proprietary; @:

distro/live-mate: distro/.live-desktop use/live/nodm use/live/ru use/x11/3d-free
	@$(call add,LIVE_LISTS,$(call tags,(desktop || mobile) && mate))

distro/live-enlightenment: distro/.live-desktop use/live/autologin \
	use/live/ru use/x11/3d-free
	@$(call add,LIVE_PACKAGES,enlightenment)

distro/live-gimp: distro/live-icewm use/x11/3d-free use/live/ru
	@$(call add,LIVE_PACKAGES,gimp tintii immix fim)
	@$(call add,LIVE_PACKAGES,cvltonemap darktable geeqie rawstudio ufraw)
	@$(call add,LIVE_PACKAGES,macrofusion python-module-pygtk-libglade)
	@$(call add,LIVE_PACKAGES,qtfm openssh-clients rsync)
	@$(call add,LIVE_PACKAGES,design-graphics-sisyphus2)

endif
