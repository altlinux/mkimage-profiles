# regular build/usage images
ifeq (distro,$(IMAGE_CLASS))

# common ground (really lowlevel)
distro/.regular-bare: distro/.base +net-eth use/kernel/net use/docs/license
	@$(call try,SAVE_PROFILE,yes)

# base target (for most images)
distro/.regular-base: distro/.regular-bare use/vmguest use/memtest +efi; @:

# graphical target (not enforcing xorg drivers or blobs)
distro/.regular-x11: distro/.regular-base +vmguest +wireless \
	use/x11/amdgpu use/live/x11 use/live/install use/live/suspend \
	use/live/repo use/live/rw use/luks use/x11/wacom use/ntp/client \
	use/branding use/browser/firefox/live use/browser/firefox/i18n \
	use/browser/firefox/h264 use/services/lvm2-disable
	@$(call add,THE_PACKAGES,disable-usb-autosuspend)
	@$(call add,LIVE_PACKAGES,volumes-profile-regular btrfs-progs)
	@$(call add,LIVE_LISTS,$(call tags,(base || desktop) && regular))
	@$(call add,LIVE_LISTS,$(call tags,base rescue))
	@$(call add,LIVE_PACKAGES,gpm livecd-install-apt-cache)
	@$(call add,DEFAULT_SERVICES_DISABLE,gpm powertop)
	@$(call add,EFI_BOOTARGS,live_rw)

# WM base target
distro/.regular-wm: distro/.regular-x11 mixin/regular-desktop; @:

# DE base target
# TODO: use/plymouth/live when luks+plymouth is done, see also #28255
distro/.regular-desktop: distro/.regular-wm \
	use/syslinux/ui/gfxboot use/firmware/laptop use/efi/refind +systemd
	@$(call add,THE_BRANDING,bootloader)
	@$(call add,THE_PACKAGES,upower bluez)
	@$(call add,THE_PACKAGES,vconsole-setup-kludge)	#28805
	@$(call add,DEFAULT_SERVICES_DISABLE,gssd idmapd krb5kdc rpcbind)
	@$(call add,DEFAULT_SERVICES_ENABLE,bluetoothd)
	@$(call set,KFLAVOURS,std-def)

distro/.regular-gtk: distro/.regular-desktop use/x11/lightdm/gtk +plymouth; @:
distro/.regular-sysv: distro/.regular-wm +sysvinit; @:
distro/.regular-sysv-gtk: distro/.regular-sysv use/syslinux/ui/gfxboot \
	use/x11/gdm2.20; @:

distro/.regular-install: distro/.regular-base +installer +sysvinit +power \
	use/branding use/bootloader/grub use/luks \
	use/install2/fs use/install2/vnc use/install2/repo
	@$(call add,INSTALL2_PACKAGES,fdisk)
	@$(call add,INSTALL2_PACKAGES,xorg-conf-synaptics)
	@$(call add,THE_LISTS,$(call tags,base regular))
	@$(call add,INSTALL2_BRANDING,alterator notes)
	@$(call add,THE_BRANDING,alterator)

# common base for the very bare distros
distro/.regular-jeos-base: distro/.regular-bare +sysvinit \
	use/isohybrid use/branding use/bootloader/grub \
	use/install2/repo use/install2/packages \
	use/net/etcnet use/power/acpi/button
	@$(call set,BOOTVGA,)
	@$(call set,INSTALLER,altlinux-generic)
	@$(call add,INSTALL2_BRANDING,alterator notes)
	@$(call add,THE_BRANDING,alterator) # just to be cleaned up later on
	@$(call add,THE_PACKAGES,apt basesystem dhcpcd vim-console)
	@$(call add,THE_LISTS,openssh)

# ...and for somewhat bare distros
distro/.regular-jeos: distro/.regular-jeos-base \
	use/bootloader/lilo use/syslinux/lateboot.cfg \
	use/install2/cleanup/everything use/install2/cleanup/kernel/everything \
	use/cleanup/jeos
	@$(call add,BASE_KMODULES,guest scsi vboxguest)
	@$(call add,BASE_PACKAGES,make-initrd-mdadm cpio)

# NB:
# - stock cleanup is not enough (or installer-common-stage3 deps soaring)
distro/regular-jeos: distro/.regular-jeos use/cleanup/jeos/full \
	use/install2/vmguest use/vmguest/base
	@$(call add,MAIN_PACKAGES,firmware-linux)
	@$(call add,INSTALL2_PACKAGES,volumes-profile-jeos)
	@$(call add,CLEANUP_PACKAGES,'glib2*' libffi 'libltdl*')
	@$(call add,CLEANUP_PACKAGES,bridge-utils)
	@$(call add,STAGE2_BOOTARGS,quiet)
	@$(call set,KFLAVOURS,un-def)

# NB: no +efi as it brings in grub2 (no ELILO support for system boot)
distro/regular-jeos-ovz: distro/.regular-jeos \
	use/server/ovz-base use/control/server/ldv use/firmware
	@$(call add,THE_PACKAGES,ipmitool lm_sensors3 mailx)

distro/.regular-install-x11: distro/.regular-install \
	use/install2/suspend mixin/regular-desktop +vmguest +wireless
	@$(call set,INSTALLER,altlinux-desktop)
	@$(call add,THE_PACKAGES,disable-usb-autosuspend)
	@$(call add,THE_LISTS,$(call tags,regular desktop))

# assumes somewhat more experienced user, mostly for sysv variants
distro/.regular-install-x11-full: distro/.regular-install-x11 \
	mixin/desktop-installer mixin/regular-desktop use/install2/fs \
	use/fonts/otf/adobe use/fonts/otf/mozilla use/fonts/chinese \
	use/branding/complete use/branding/slideshow/once \
	use/net-eth/dhcp use/efi/refind use/efi/shell use/rescue/base
	@$(call add,RESCUE_LISTS,$(call tags,rescue misc))
	@$(call add,MAIN_PACKAGES,anacron man-whatis usb-modeswitch)

distro/regular-icewm: distro/.regular-sysv-gtk +icewm +nm \
	use/x11/lightdm/gtk use/init/sysv/polkit use/deflogin/sysv/nm \
	use/browser/chromium use/fonts/ttf/redhat
	@$(call add,LIVE_LISTS,$(call tags,desktop nm))
	@$(call add,LIVE_LISTS,$(call tags,regular icewm))
	@$(call add,LIVE_PACKAGES,mnt winswitch xpra)
	@$(call add,LIVE_PACKAGES,icewm-startup-networkmanager)
	@$(call set,KFLAVOURS,un-def)

# wdm can't do autologin so add standalone one for livecd
distro/regular-wmaker: distro/.regular-sysv \
	mixin/regular-wmaker use/live/autologin use/browser/palemoon/i18n
	@$(call add,LIVE_PACKAGES,wdm wmxkbru)

distro/regular-gnustep: distro/.regular-sysv \
	mixin/regular-wmaker mixin/regular-gnustep; @:
distro/regular-gnustep-systemd: distro/.regular-wm +systemd \
	mixin/regular-wmaker mixin/regular-gnustep; @:

distro/regular-xfce: distro/.regular-gtk mixin/regular-xfce \
	use/x11/xfce/full use/domain-client
	@$(call set,KFLAVOURS,un-def)

distro/regular-xfce-sysv: distro/.regular-sysv-gtk \
	mixin/regular-xfce mixin/regular-xfce-sysv; @:

distro/regular-lxde: distro/.regular-gtk mixin/regular-lxde
	@$(call add,THE_PACKAGES,lxde)

distro/regular-lxde-sysv: distro/.regular-sysv-gtk mixin/regular-lxde
	@$(call add,THE_PACKAGES,lxde-sysvinit)

distro/regular-xmonad: distro/.regular-gtk use/x11/xmonad
	@$(call add,LIVE_PACKAGES,livecd-regular-xmonad)

distro/regular-mate: distro/.regular-gtk +nm \
	use/x11/mate use/fonts/ttf/google use/domain-client
	@$(call add,LIVE_LISTS,$(call tags,mobile mate))
	@$(call add,LIVE_LISTS,$(call tags,desktop sane))
	@$(call add,LIVE_LISTS,$(call tags,base smartcard))

distro/regular-enlightenment: distro/.regular-gtk \
	use/x11/enlightenment use/fonts/infinality; @:

distro/regular-enlightenment-sysv: distro/.regular-sysv-gtk \
	use/x11/enlightenment
	@$(call set,META_VOL_ID,ALT regular-E-SysV/$(ARCH)) # see also #28271

distro/regular-cinnamon: distro/.regular-gtk \
	use/x11/cinnamon use/fonts/infinality use/fonts/ttf/google \
	use/net/nm/mmgui use/im; @:

# not .regular-gtk due to gdm vs lightdm
distro/regular-gnome3: distro/.regular-desktop +plymouth +nm \
	use/x11/gnome3 use/browser/epiphany use/fonts/ttf/redhat
	@$(call set,KFLAVOURS,un-def)
	@$(call add,LIVE_PACKAGES,livecd-gnome3-setup-done)
	@$(call add,LIVE_PACKAGES,gnome3-regular xcalib templates)
	@$(call add,LIVE_PACKAGES,gnome-flashback screenpen)

distro/regular-tde: distro/.regular-desktop mixin/regular-tde +plymouth \
	use/x11/gtk/nm use/net/nm/mmgui

distro/regular-tde-sysv: distro/.regular-sysv mixin/regular-tde \
	use/net-eth/dhcp use/efi/refind; @:

distro/regular-kde4: distro/.regular-desktop use/x11/kde4/nm use/x11/kdm4 \
	use/browser/konqueror4 use/fonts/zerg use/domain-client \
	use/net/nm/mmgui +pulse +plymouth
	@$(call add,THE_LISTS,$(call tags,regular kde4))
	@$(call add,THE_PACKAGES,fonts-ttf-levien-inconsolata)
	@$(call set,THE_IMAGEWRITER,rosa-imagewriter)
	@$(call add,DEFAULT_SERVICES_ENABLE,prefdm)

distro/regular-lxqt: distro/.regular-desktop mixin/regular-lxqt; @:

distro/regular-lxqt-sysv: distro/.regular-sysv mixin/regular-lxqt \
	use/net-eth/dhcp use/efi/refind; @:

distro/regular-kde5: distro/.regular-desktop \
	use/x11/kde5 use/x11/sddm use/domain-client \
	use/fonts/ttf/google use/fonts/ttf/redhat use/fonts/zerg \
	+nm +pulse +plymouth
	@$(call add,THE_PACKAGES,kde5-telepathy)
	@$(call set,THE_IMAGEWRITER,rosa-imagewriter)

distro/regular-rescue: distro/.regular-base mixin/regular-rescue  \
	use/rescue/rw use/efi/refind use/efi/shell use/efi/memtest86 \
	use/hdt use/syslinux/rescue_fm.cfg use/syslinux/rescue_remote.cfg \
	use/mediacheck +wireless
	@$(call set,KFLAVOURS,un-def)
	@$(call add,RESCUE_PACKAGES,gpm livecd-net-eth)
	@$(call add,RESCUE_LISTS,$(call tags,base bench))
	@$(call add,RESCUE_LISTS,$(call tags,network security))

distro/regular-rescue-netbootxyz: distro/.regular-bare mixin/regular-rescue
	@$(call set,RELNAME,en.altlinux.org/rescue (netboot.xyz edition))
	@$(call set,META_VOL_ID,ALT Rescue)
	@$(call set,META_APP_ID,$(ARCH))

distro/regular-sysv-tde: distro/.regular-install-x11-full mixin/regular-tde
	@$(call add,THE_LISTS,$(call tags,base desktop))
	@$(call add,THE_LISTS,$(call tags,regular tde))
	@$(call add,THE_PACKAGES,kpowersave)

distro/regular-sysv-xfce: distro/.regular-install-x11-full \
	mixin/regular-xfce mixin/regular-xfce-sysv; @:

distro/.regular-server-base: distro/.regular-install \
	use/server/base use/stage2/kms
	@$(call add,THE_LISTS,$(call tags,server && (regular || network)))
	@$(call set,INSTALLER,altlinux-server)
	@$(call add,SYSTEM_PACKAGES,multipath-tools)
	@$(call add,INSTALL2_PACKAGES,installer-feature-multipath)

distro/.regular-server: distro/.regular-server-base \
	use/server/mini use/firmware/qlogic use/rescue/base use/cleanup/libs
	@$(call add,RESCUE_LISTS,$(call tags,rescue misc))
	@$(call add,MAIN_PACKAGES,aptitude)
	@$(call add,CLEANUP_PACKAGES,qt4-common)
	@$(call add,DEFAULT_SERVICES_DISABLE,bridge)

distro/.regular-server-managed: distro/.regular-server
	@$(call add,THE_PACKAGES,alterator-fbi)
	@$(call add,THE_LISTS,$(call tags,server alterator))
	@$(call add,INSTALL2_PACKAGES,ntfs-3g)
	@$(call add,DEFAULT_SERVICES_DISABLE,ahttpd alteratord)

distro/regular-server: distro/.regular-server-managed \
	use/server/groups/base use/install2/vnc/full
	@$(call add,MAIN_GROUPS,server/sambaDC)
	@$(call add,MAIN_GROUPS,tools/hyperv)

distro/regular-server-ovz: distro/.regular-server \
	use/server/ovz use/server/groups/tools use/cleanup/x11-alterator
	@$(call add,MAIN_GROUPS,tools/vzstats)

distro/regular-server-hyperv: distro/.regular-server-managed
	@$(call set,KFLAVOURS,un-def)
	@$(call add,THE_PACKAGES,hyperv-daemons)
	@$(call add,DEFAULT_SERVICES_DISABLE,bridge smartd)
	@$(call add,DEFAULT_SERVICES_DISABLE,cpufreq-simple powertop)

distro/.regular-server-openstack: distro/.regular-server-base \
	use/firmware/qlogic use/server/groups/openstack
	@$(call add,MAIN_GROUPS,tools/ipmi tools/monitoring)

distro/regular-server-openstack: distro/.regular-server-openstack +systemd; @:

distro/regular-server-openstack-sysv: distro/.regular-server-openstack +sysvinit
	@$(call add,DEFAULT_SERVICES_DISABLE,lvm2-lvmetad)

distro/regular-server-pve: distro/.regular-server-base \
	use/firmware/qlogic +efi +systemd
	@$(call set,BASE_BOOTLOADER,grub)
	@$(call set,INSTALLER,altlinux-server)
	@$(call add,INSTALL2_PACKAGES,installer-feature-pve)
	@$(call add,THE_PACKAGES,pve-manager nfs-clients su)
	@$(call add,THE_PACKAGES,bridge-utils dhcpcd faketime tzdata postfix)
	@$(call add,THE_KMODULES,ipset kvm)
	@$(call add,DEFAULT_SERVICES_DISABLE,pve-manager pve-cluster \
		pve-firewall pve-ha-crm pve-manager pveproxy pvedaemon \
		pvefw-logger pve-ha-lrm pvenetcommit pvestatd spiceproxy)

distro/regular-builder: distro/.regular-bare \
	use/dev/builder/full +sysvinit +efi +power \
	use/live/base use/live/rw use/live/repo/online use/live/textinstall \
	use/isohybrid use/syslinux/timeout/30 \
	use/stage2/net-eth use/net-eth/dhcp
	@$(call add,LIVE_PACKAGES,cifs-utils elinks lftp openssh wget)
	@$(call add,LIVE_PACKAGES,bash-completion gpm screen tmux zsh)
	@$(call add,LIVE_PACKAGES,ccache rpm-utils wodim)
	@$(call add,DEFAULT_SERVICES_ENABLE,gpm)

distro/regular-server-samba4: distro/.regular-server-managed
	@$(call add,THE_LISTS,$(call tags,server && (sambaDC || alterator)))
	@$(call add,THE_PACKAGES,alterator-dhcp)
	@$(call add,DEFAULT_SERVICES_DISABLE,smbd nmbd winbind)

distro/regular-engineering: distro/regular-lxde use/live/ru
	@$(call add,THE_PACKAGES,lxde-settings-lxdesktop)
	@$(call add,THE_LISTS,$(call tags,engineering desktop))
	@$(call add,LIVE_LISTS,$(call tags,desktop sane))
	@$(call add,THE_PACKAGES,LibreOffice LibreOffice-gnome LibreOffice-langpack-ru)
	@$(call add,THE_PACKAGES,firefox-pepperflash)
	@$(call add,THE_PACKAGES,cups system-config-printer)
	@$(call add,THE_PACKAGES,gnome-disk-utility)
	@$(call add,THE_PACKAGES,evince)
	@$(call add,LIVE_KMODULES,staging)
	@$(call add,DEFAULT_SERVICES_ENABLE,cups)
	@$(call add,DEFAULT_SERVICES_ENABLE,ModemManager)

endif
