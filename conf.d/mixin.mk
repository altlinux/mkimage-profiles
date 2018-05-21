### various mixins with their origin

### desktop.mk
mixin/desktop-installer: +net-eth +vmguest \
	use/x11-autostart use/fonts/install2 use/sound
	@$(call add,BASE_LISTS, \
		$(call tags,(base || desktop) && (l10n || network)))
	@$(call add,INSTALL2_PACKAGES,ntfs-3g)
	@$(call add,BASE_PACKAGES,os-prober)

### e2k.mk
mixin/e2k-base: use/tty/S0 use/net-eth/dhcp; @:

mixin/e2k-desktop: use/e2k/x11 use/l10n/default/ru_RU \
	use/browser/firefox/esr use/browser/firefox/i18n \
	use/fonts/otf/adobe use/fonts/otf/mozilla
	@$(call add,THE_PACKAGES,xinit xterm mc)
	@$(call add,THE_PACKAGES,fonts-bitmap-terminus)

mixin/e2k-livecd-install: use/e2k/x11
	@$(call add,THE_PACKAGES,livecd-install alterator-notes)
	@$(call add,THE_PACKAGES,fdisk hdparm rsync openssh vim-console)
	@$(call add,THE_PACKAGES,apt-repo)

mixin/e2k-mate: use/e2k/x11 use/x11/xorg use/fonts/install2 \
	use/deflogin/live use/x11/mate use/x11/lightdm/gtk \
	use/fonts/otf/adobe use/fonts/otf/mozilla \
	use/fonts/ttf/google use/fonts/ttf/redhat
	@$(call set,INSTALLER,altlinux-desktop)
	@$(call add,THE_BRANDING,mate-settings)
	@$(call add,THE_BRANDING,alterator)
	@$(call add,THE_BRANDING,graphics)
	@$(call add,THE_PACKAGES,setup-mate-terminal)
	@$(call add,THE_PACKAGES,alterator-standalone)
	@$(call add,THE_PACKAGES,terminfo-extra)
	@$(call add,THE_PACKAGES,ethtool net-tools ifplugd)
	@$(call add,THE_PACKAGES,zsh bash-completion)

### regular.mk
# common WM live/installer bits
mixin/regular-desktop: use/x11/xorg +alsa use/xdg-user-dirs
	@$(call add,THE_PACKAGES,pam-limits-desktop beesu)
	@$(call add,THE_PACKAGES,installer-feature-desktop-other-fs-stage2)
	@$(call add,THE_PACKAGES,alterator-notes dvd+rw-tools)
	@$(call add,THE_BRANDING,alterator graphics indexhtml notes)
	@$(call add,THE_PACKAGES,$$(THE_IMAGEWRITER))
	@$(call set,THE_IMAGEWRITER,imagewriter)

mixin/regular-wmaker: use/efi/refind use/syslinux/ui/gfxboot \
	use/fonts/ttf/redhat use/x11/wmaker
	@$(call add,LIVE_PACKAGES,livecd-install-wmaker)
	@$(call add,LIVE_PACKAGES,installer-feature-no-xconsole-stage3)
	@$(call add,MAIN_PACKAGES,wmgtemp wmhdaps wmpomme wmxkbru xxkb)

# gdm2.20 can reboot/halt with both sysvinit and systemd, and is slim
mixin/regular-gnustep: use/x11/gnustep use/x11/gdm2.20 use/mediacheck \
	use/browser/firefox/classic
	@$(call add,THE_BRANDING,graphics)

mixin/regular-xfce: use/x11/xfce use/fonts/ttf/redhat use/x11/gtk/nm +nm; @:

mixin/regular-xfce-sysv: use/init/sysv/polkit use/deflogin/sysv/nm \
	use/x11/lightdm/gtk \
	use/browser/palemoon/suggested \
	use/fonts/otf/adobe use/fonts/otf/mozilla
	@$(call add,THE_PACKAGES,pnmixer pm-utils elinks mpg123)
	@$(call add,THE_PACKAGES,alsa-oss ossp whdd wget cdrkit)

mixin/regular-lxde: use/x11/lxde use/x11/gtk/nm use/im \
	use/browser/palemoon/i18n +nm
	@$(call add,LIVE_LISTS,$(call tags,desktop gvfs))
	@$(call add,THE_PACKAGES,qasmixer qpdfview)
	@$(call set,THE_IMAGEWRITER,rosa-imagewriter)

mixin/regular-tde: +tde \
	use/syslinux/ui/gfxboot use/browser/firefox/classic use/fonts/ttf/redhat
	@$(call add,THE_PACKAGES_REGEXP,kdeedu-kalzium.* kdeedu-ktouch.*)
	@$(call add,DEFAULT_SERVICES_DISABLE,upower bluetoothd)

mixin/regular-lxqt: use/x11/lxqt use/x11/sddm \
	use/browser/falkon use/x11/gtk/nm +nm +plymouth
	@$(call set,THE_IMAGEWRITER,rosa-imagewriter)

# NB: never ever use/syslinux/ui/gfxboot here as gfxboot mangles
#     kernel cmdline resulting in method:disk instead of method:cdrom
#     which will change propagator's behaviour to probe additional
#     filesystems (ro but no loop) thus potentially writing to
#     an unrecovered filesystem's journal
mixin/regular-rescue: use/rescue use/isohybrid use/luks use/branding \
	use/syslinux/ui/menu use/syslinux/timeout/600 \
	use/firmware/qlogic test/rescue/no-x11 +sysvinit; @:

### vm.mk
mixin/cloud-init:
	@$(call add,BASE_PACKAGES,cloud-init)
	@$(call add,DEFAULT_SERVICES_ENABLE,cloud-config cloud-final)
	@$(call add,DEFAULT_SERVICES_ENABLE,cloud-init cloud-init-local)

mixin/opennebula-context:
	@$(call add,BASE_PACKAGES,opennebula-context)
	@$(call add,DEFAULT_SERVICES_ENABLE,one-context-local one-context)

mixin/icewm: use/x11/lightdm/gtk +icewm; @:
