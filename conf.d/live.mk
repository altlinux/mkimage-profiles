# live images
ifeq (distro,$(IMAGE_CLASS))

distro/syslinux: distro/.init \
	use/syslinux/localboot.cfg use/syslinux/ui-vesamenu \
	use/hdt use/memtest

distro/dos: distro/.init use/dos use/syslinux/ui-menu
distro/rescue: distro/.base use/rescue use/syslinux/ui-menu
distro/live-systemd: distro/.base use/live/base use/systemd

distro/.live-base: distro/.base use/live/base use/power/acpi/button
distro/.live-desktop: distro/.base use/syslinux/ui-vesamenu +live

distro/live-isomd5sum: distro/.base use/live/base use/isomd5sum
	@$(call add,LIVE_PACKAGES,livecd-isomd5sum)

distro/live-builder: pkgs := livecd-tmpfs livecd-online-repo mkimage-profiles
distro/live-builder: distro/.live-base use/dev/mkimage use/dev/repo
	@$(call add,LIVE_LISTS,$(call tags,base && (server || builder)))
	@$(call add,LIVE_PACKAGES,zsh sudo)
	@$(call add,LIVE_PACKAGES,$(pkgs))
	@$(call add,MAIN_PACKAGES,$(pkgs))
	@$(call add,MAIN_PACKAGES,syslinux pciids memtest86+ mkisofs)

distro/live-install: distro/.live-base use/syslinux/localboot.cfg
	@$(call add,LIVE_PACKAGES,live-install)

distro/live-icewm: distro/.live-desktop use/live/autologin +icewm
distro/live-razorqt: distro/.live-desktop +razorqt
distro/live-tde: distro/.live-desktop +tde

distro/live-rescue: distro/live-icewm
	@$(call add,LIVE_LISTS,$(call tags,rescue && (fs || live || x11)))
	@$(call add,LIVE_LISTS, \
		$(call tags,(base || extra) && (archive || rescue || network)))

distro/live-webkiosk: distro/.live-desktop use/live/autologin use/live/hooks
	@$(call add,LIVE_PACKAGES,livecd-webkiosk)
	@$(call add,LIVE_PACKAGES,fonts-ttf-dejavu fonts-ttf-droid)

endif
