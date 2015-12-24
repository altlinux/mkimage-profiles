# regular build/usage images
ifeq (distro,$(IMAGE_CLASS))

# common ground (really lowlevel)
distro/.regular-bare: distro/.base +net-eth use/kernel/net
	@$(call try,SAVE_PROFILE,yes)

# base target (for most images)
distro/.regular-base: distro/.regular-bare use/memtest +efi; @:

# graphical target (not enforcing xorg drivers or blobs)
distro/.regular-x11: distro/.regular-base +vmguest +wireless \
	use/live/x11 use/live/install use/live/suspend \
	use/live/repo use/live/rw use/luks use/x11/wacom use/ntp/client \
	use/branding use/browser/firefox/live use/browser/firefox/i18n
	@$(call add,LIVE_LISTS,$(call tags,(base || desktop) && regular))
	@$(call add,LIVE_LISTS,$(call tags,base rescue))
	@$(call add,LIVE_PACKAGES,gpm livecd-install-apt-cache)
	@$(call add,DEFAULT_SERVICES_ENABLE,gpm)
	@$(call add,EFI_BOOTARGS,live_rw)

# common WM live/installer bits
mixin/regular-desktop: use/x11/xorg use/sound use/xdg-user-dirs
	@$(call add,THE_PACKAGES,installer-feature-desktop-other-fs-stage2)
	@$(call add,THE_PACKAGES,alterator-notes)
	@$(call add,THE_BRANDING,alterator graphics indexhtml notes)
	@$(call add,THE_PACKAGES,$$(THE_IMAGEWRITER))
	@$(call set,THE_IMAGEWRITER,imagewriter)

# WM base target
distro/.regular-wm: distro/.regular-x11 mixin/regular-desktop

# DE base target
# TODO: use/plymouth/live when luks+plymouth is done, see also #28255
distro/.regular-desktop: distro/.regular-wm \
	use/syslinux/ui/gfxboot use/firmware/laptop use/efi/refind +systemd
	@$(call add,LIVE_LISTS,domain-client)
	@$(call add,THE_BRANDING,bootloader)
	@$(call add,THE_PACKAGES,upower bluez)
	@$(call add,DEFAULT_SERVICES_DISABLE,gssd idmapd krb5kdc rpcbind)
	@$(call set,KFLAVOURS,std-def)

distro/.regular-gtk: distro/.regular-desktop use/x11/lightdm/gtk +plymouth; @:
distro/.regular-sysv: distro/.regular-wm +sysvinit; @:
distro/.regular-sysv-gtk: distro/.regular-sysv use/syslinux/ui/gfxboot \
	use/x11/gdm2.20; @:

distro/.regular-install: distro/.regular-base +installer +sysvinit +power \
	use/branding use/bootloader/grub use/luks \
	use/install2/fs use/install2/vnc use/install2/repo
	@$(call add,THE_LISTS,$(call tags,base regular))
	@$(call add,INSTALL2_BRANDING,alterator notes)
	@$(call add,THE_BRANDING,alterator)

# NB:
# - no +power or even use/power/acpi/button on intent
# - stock cleanup is not enough (or installer-common-stage3 deps soaring)
distro/regular-jeos: distro/.regular-bare use/isohybrid +sysvinit \
	use/branding use/bootloader/lilo use/syslinux/lateboot.cfg \
	use/install2/vmguest use/vmguest/base \
	use/install2/repo use/install2/packages \
	use/install2/cleanup/everything use/install2/cleanup/kernel/everything \
	use/cleanup/x11-alterator use/net/etcnet use/power/acpi/button
	@$(call add,BASE_KMODULES,guest scsi vboxguest)
	@$(call set,INSTALLER,altlinux-generic)
	@$(call add,INSTALL2_PACKAGES,volumes-profile-jeos)
	@$(call add,INSTALL2_BRANDING,alterator notes)
	@$(call add,THE_BRANDING,alterator) # just to be cleaned up later on
	@$(call add,THE_PACKAGES,apt basesystem dhcpcd openssh vim-console)
	@$(call add,THE_PACKAGES,bash-completion)
	@# a *lot* of stray things get pulled in by alterator modules
	@$(call add,CLEANUP_PACKAGES,libfreetype fontconfig)
	@$(call add,CLEANUP_PACKAGES,'glib2*' libffi 'libltdl*')
	@$(call add,CLEANUP_PACKAGES,liblcms libjpeg 'libpng*' 'libtiff*')
	@$(call add,CLEANUP_PACKAGES,avahi-autoipd bridge-utils) # i-c-stage3
	@$(call add,CLEANUP_PACKAGES,iw wpa_supplicant)
	@$(call add,CLEANUP_PACKAGES,openssl libpcsclite)
	@# fully fledged interactivesystem isn't needed here either
	@$(call add,CLEANUP_PACKAGES,interactivesystem 'groff*' man stmpclean)
	@$(call add,CLEANUP_PACKAGES,glibc-gconv-modules gettext)
	@$(call add,CLEANUP_PACKAGES,console-scripts console-vt-tools 'kbd*')
	@$(call add,CLEANUP_PACKAGES,libsystemd-journal libsystemd-login)
	@$(call add,CLEANUP_PACKAGES,dbus libdbus libcap-ng)
	@$(call add,STAGE2_BOOTARGS,quiet)

distro/.regular-install-x11: distro/.regular-install \
	use/install2/suspend mixin/regular-desktop +vmguest +wireless
	@$(call set,INSTALLER,altlinux-desktop)
	@$(call add,THE_LISTS,$(call tags,regular desktop))

distro/regular-icewm: distro/.regular-sysv-gtk +icewm \
	use/browser/seamonkey/i18n use/fonts/ttf/redhat
	@$(call add,LIVE_LISTS,$(call tags,regular icewm))
	@$(call add,LIVE_PACKAGES,mnt winswitch xpra)
	@$(call set,KFLAVOURS,un-def)

mixin/regular-wmaker: use/efi/refind use/syslinux/ui/gfxboot \
	use/fonts/ttf/redhat use/x11/wmaker
	@$(call add,LIVE_PACKAGES,livecd-install-wmaker)
	@$(call add,LIVE_PACKAGES,installer-feature-no-xconsole-stage3)
	@$(call add,MAIN_PACKAGES,wmgtemp wmhdaps wmpomme wmxkbru xxkb)

# wdm can't do autologin so add standalone one for livecd
distro/regular-wmaker: distro/.regular-sysv \
	mixin/regular-wmaker use/live/autologin use/browser/seamonkey/i18n
	@$(call add,LIVE_PACKAGES,wdm wmxkbru)

# gdm2.20 can reboot/halt with both sysvinit and systemd, and is slim
mixin/regular-gnustep: use/x11/gnustep use/x11/gdm2.20 use/mediacheck \
	use/browser/firefox/classic
	@$(call add,THE_BRANDING,graphics)

distro/regular-gnustep: distro/.regular-sysv \
	mixin/regular-wmaker mixin/regular-gnustep; @:
distro/regular-gnustep-systemd: distro/.regular-wm +systemd \
	mixin/regular-wmaker mixin/regular-gnustep; @:

distro/regular-xfce: distro/.regular-gtk \
	use/x11/xfce use/domain-client/full use/browser/firefox/classic \
	use/fonts/ttf/redhat use/x11/gtk/nm +nm; @:

distro/regular-xfce-sysv: distro/.regular-sysv-gtk \
	use/init/sysv/polkit use/x11/xfce \
	use/fonts/ttf/redhat use/fonts/otf/adobe use/fonts/otf/mozilla
	@$(call set,KFLAVOURS,un-def)
	@$(call add,LIVE_PACKAGES,xfce4-mixer pm-utils bc elinks mpg123)

distro/regular-lxde: distro/.regular-gtk use/x11/lxde use/fonts/infinality \
	use/x11/gtk/nm use/im +nm
	@$(call add,LIVE_LISTS,$(call tags,desktop gvfs))

distro/regular-xmonad: distro/.regular-gtk use/x11/xmonad
	@$(call add,LIVE_PACKAGES,livecd-regular-xmonad)

distro/regular-mate: distro/.regular-gtk +nm \
	use/x11/mate use/fonts/ttf/google use/domain-client/full
	@$(call add,LIVE_LISTS,$(call tags,mobile mate))
	@$(call add,LIVE_LISTS,$(call tags,desktop sane))

distro/regular-e17: distro/.regular-gtk use/x11/e17 use/fonts/infinality; @:

distro/regular-enlightenment: distro/.regular-gtk \
	use/x11/enlightenment use/fonts/infinality
	@$(call set,META_VOL_ID,ALT Linux regular-E/$(ARCH))

distro/regular-enlightenment-sysv: distro/.regular-sysv-gtk \
	use/x11/enlightenment
	@$(call set,META_VOL_ID,ALT Linux regular-E-SysV/$(ARCH))

distro/regular-cinnamon: distro/.regular-gtk \
	use/x11/cinnamon use/fonts/infinality use/net/nm/mmgui use/im
	@$(call set,META_VOL_ID,ALT Linux $(IMAGE_NAME)) # see also #28271

# not .regular-gtk due to gdm vs lightdm
distro/regular-gnome3: distro/.regular-desktop +plymouth +nm \
	use/x11/gnome3 use/browser/epiphany use/fonts/ttf/redhat
	@$(call set,KFLAVOURS,un-def)
	@$(call add,LIVE_PACKAGES_REGEXP,^setup-gnome3-done.*)
	@$(call add,LIVE_PACKAGES,gnome3-regular xcalib templates)
	@$(call add,LIVE_PACKAGES,gnome-flashback)

# reusable bits
mixin/regular-tde: +tde \
	use/syslinux/ui/gfxboot use/browser/firefox/classic use/fonts/ttf/redhat
	@$(call add,THE_PACKAGES,kdeedu)
	@$(call add,DEFAULT_SERVICES_DISABLE,upower bluez)

distro/regular-tde: distro/.regular-desktop mixin/regular-tde +plymouth \
	use/x11/gtk/nm use/net/nm/mmgui
	@$(call add,THE_LISTS,openscada)

distro/regular-tde-sysv: distro/.regular-sysv mixin/regular-tde \
	use/net-eth/dhcp use/efi/refind; @:

distro/regular-kde4: distro/.regular-desktop use/x11/kde4/nm use/x11/kdm4 \
	use/browser/konqueror4 use/fonts/zerg use/domain-client/full \
	use/net/nm/mmgui +pulse +plymouth
	@$(call add,THE_LISTS,$(call tags,regular kde4))
	@$(call add,THE_PACKAGES,volumes-profile-lite)
	@$(call set,THE_IMAGEWRITER,rosa-imagewriter)
	@$(call add,DEFAULT_SERVICES_ENABLE,prefdm)

mixin/regular-lxqt: use/x11/lxqt use/x11/sddm \
	use/net/connman use/browser/qupzilla +plymouth
	@$(call add,THE_PACKAGES,qconnman-ui)
	@$(call set,THE_IMAGEWRITER,rosa-imagewriter)

distro/regular-lxqt: distro/.regular-desktop mixin/regular-lxqt; @:

distro/regular-lxqt-sysv: distro/.regular-sysv mixin/regular-lxqt \
	use/net-eth/dhcp use/efi/refind; @:

distro/regular-sugar: distro/.regular-gtk use/x11/sugar; @:

distro/regular-leechcraft: distro/.regular-desktop \
	use/x11/leechcraft use/x11/lightdm/lxqt +pulse; @:

distro/regular-kde5: distro/.regular-desktop \
	use/x11/kde5 use/x11/sddm \
	use/fonts/ttf/google use/fonts/ttf/redhat use/fonts/zerg \
	+nm +pulse +plymouth
	@$(call add,THE_PACKAGES,kde5-telepathy)
	@$(call set,THE_IMAGEWRITER,rosa-imagewriter)

# NB: never ever use/syslinux/ui/gfxboot here as gfxboot mangles
#     kernel cmdline resulting in method:disk instead of method:cdrom
#     which will change propagator's behaviour to probe additional
#     filesystems (ro but no loop) thus potentially writing to
#     an unrecovered filesystem's journal
distro/regular-rescue: distro/.regular-base use/rescue/rw use/luks \
	use/branding use/efi/refind use/efi/shell use/efi/memtest86 \
	use/hdt use/syslinux/ui/menu use/syslinux/timeout/600 \
	use/syslinux/rescue_fm.cfg use/syslinux/rescue_remote.cfg \
	use/firmware/qlogic use/mediacheck test/rescue/no-x11 \
	+wireless +sysvinit
	@$(call set,KFLAVOURS,un-def)
	@$(call add,RESCUE_PACKAGES,gpm livecd-net-eth)
	@$(call add,RESCUE_LISTS,$(call tags,base && (smartcard || bench)))
	@$(call add,RESCUE_LISTS,$(call tags,network security))

distro/regular-sysv-tde: distro/.regular-install-x11 \
	mixin/desktop-installer mixin/regular-tde use/install2/fs \
	use/branding/complete use/branding/slideshow/once \
	use/net-eth/dhcp use/efi/refind use/efi/shell use/rescue/base \
	use/fonts/otf/adobe use/fonts/otf/mozilla
	@$(call add,RESCUE_LISTS,$(call tags,rescue misc))
	@$(call add,THE_LISTS,$(call tags,base desktop))
	@$(call add,THE_LISTS,$(call tags,regular tde))
	@$(call add,THE_PACKAGES,kpowersave)
	@$(call add,MAIN_PACKAGES,anacron man-whatis usb-modeswitch)

distro/.regular-server: distro/.regular-install \
	use/server/mini use/firmware/qlogic use/rescue/base use/cleanup/x11
	@$(call add,THE_LISTS,$(call tags,regular server))
	@$(call add,MAIN_PACKAGES,aptitude)
	@$(call set,INSTALLER,altlinux-server)
	@$(call add,CLEANUP_PACKAGES,qt4-common)
	@$(call add,DEFAULT_SERVICES_DISABLE,bridge)

distro/regular-server: distro/.regular-server use/cleanup/x11-alterator; @:

distro/.regular-server-managed: distro/.regular-server
	@$(call add,THE_PACKAGES,alterator-fbi)
	@$(call add,THE_LISTS,$(call tags,server alterator))
	@$(call add,DEFAULT_SERVICES_DISABLE,ahttpd alteratord)

distro/regular-server-ovz: distro/.regular-server-managed \
	use/server/ovz use/server/groups/base
	@$(call add,MAIN_GROUPS,vzstats)

distro/regular-server-hyperv: distro/.regular-server-managed
	@$(call set,KFLAVOURS,un-def)
	@$(call add,INSTALL2_PACKAGES,ntfs-3g)
	@$(call add,THE_PACKAGES,hyperv-daemons)
	@$(call add,DEFAULT_SERVICES_DISABLE,bridge cpufreq-simple)

distro/regular-builder: distro/.regular-bare \
	use/dev/builder/full +sysvinit +efi +power \
	use/live/base use/live/rw use/live/repo/online use/live/textinstall \
	use/isohybrid use/syslinux/timeout/30 \
	use/stage2/net-eth use/net-eth/dhcp
	@$(call add,LIVE_PACKAGES,cifs-utils elinks lftp openssh wget)
	@$(call add,LIVE_PACKAGES,bash-completion gpm screen tmux zsh)
	@$(call add,LIVE_PACKAGES,ccache rpm-utils wodim)
	@$(call add,DEFAULT_SERVICES_ENABLE,gpm)

distro/regular-server-samba4: distro/regular-server
	@$(call add,THE_LISTS,$(call tags,server && (sambaDC || alterator)))
	@$(call add,THE_PACKAGES,alterator-fbi alterator-dhcp)
	@$(call add,DEFAULT_SERVICES_DISABLE,smbd nmbd winbind)

endif
