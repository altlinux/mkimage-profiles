# live images
ifeq (distro,$(IMAGE_CLASS))

distro/syslinux: distro/.init \
	use/syslinux/localboot.cfg use/syslinux/ui/vesamenu use/hdt; @:

distro/dos: distro/.init use/dos use/syslinux/ui/menu; @:
distro/rescue: distro/.base use/rescue use/syslinux/ui/menu; @:
distro/live-systemd: distro/.base use/live/base use/systemd; @:

distro/.live-base: distro/.base use/live/base use/power/acpi/button; @:
distro/.live-desktop: distro/.base +live use/syslinux/ui/vesamenu; @:

distro/.live-kiosk: distro/.base use/live/base use/live/autologin \
	use/syslinux/timeout/1 use/cleanup +power
	@$(call add,LIVE_PACKAGES,fonts-ttf-dejavu)
	@$(call add,CLEANUP_PACKAGES,'alterator*' 'guile*' 'vim-common')

distro/live-isomd5sum: distro/.base use/live/base use/isomd5sum
	@$(call add,LIVE_PACKAGES,livecd-isomd5sum)

distro/live-builder: pkgs := livecd-tmpfs livecd-online-repo mkimage-profiles
distro/live-builder: distro/.live-base use/dev/mkimage use/dev/repo
	@$(call set,KFLAVOURS,$(BIGRAM))
	@$(call add,LIVE_LISTS,$(call tags,base && (server || builder)))
	@$(call add,LIVE_PACKAGES,zsh sudo)
	@$(call add,LIVE_PACKAGES,$(pkgs))
	@$(call add,MAIN_PACKAGES,$(pkgs))
	@$(call add,MAIN_PACKAGES,syslinux pciids memtest86+ mkisofs)

distro/live-install: distro/.live-base use/syslinux/localboot.cfg
	@$(call add,LIVE_PACKAGES,live-install)

distro/.livecd-install: distro/.live-base use/syslinux/localboot.cfg
	@$(call add,LIVE_PACKAGES,livecd-install)

distro/live-icewm: distro/.live-desktop use/live/autologin +icewm; @:
distro/live-razorqt: distro/.live-desktop +razorqt; @:
distro/live-tde: distro/.live-desktop use/live/ru +tde; @:

distro/live-rescue: distro/live-icewm
	@$(call add,LIVE_LISTS,$(call tags,rescue && (fs || live || x11)))
	@$(call add,LIVE_LISTS, \
		$(call tags,(base || extra) && (archive || rescue || network)))

distro/live-webkiosk-mini: distro/.live-kiosk use/live/hooks use/live/ru
	@$(call add,LIVE_LISTS,$(call tags,desktop && (live || network)))
	@$(call add,LIVE_PACKAGES,livecd-webkiosk)
	@$(call add,CLEANUP_PACKAGES,'libqt4*' 'qt4*')

distro/live-webkiosk: distro/live-webkiosk-mini use/live/desktop; @:

distro/live-flightgear: distro/live-icewm use/live/sound use/x11/3d-proprietary
	@$(call add,LIVE_PACKAGES,FlightGear fgo input-utils)
	@$(call try,HOMEPAGE,http://www.4p8.com/eric.brasseur/flight_simulator_tutorial.html)

distro/live-cinnamon: distro/.live-desktop use/live/autologin use/live/ru \
	use/x11/cinnamon use/x11/3d-free

distro/live-enlightenment: distro/.live-desktop use/live/autologin use/live/ru use/x11/3d-free
	@$(call add,LIVE_PACKAGES,enlightenment)

distro/live-gimp: distro/live-icewm use/x11/3d-free use/live/ru
	@$(call add,LIVE_PACKAGES,gimp tintii immix fim)
	@$(call add,LIVE_PACKAGES,cvltonemap darktable geeqie rawstudio ufraw)
	@$(call add,LIVE_PACKAGES,macrofusion python-module-pygtk-libglade)
	@$(call add,LIVE_PACKAGES,qtfm openssh-clients rsync)
	@$(call add,LIVE_PACKAGES,design-graphics-sisyphus2)

endif
