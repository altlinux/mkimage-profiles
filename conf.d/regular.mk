# regular build/usage images
ifeq (distro,$(IMAGE_CLASS))

# common ground (really lowlevel)
distro/.regular-bare: distro/.base +net-eth use/kernel/net use/docs/license \
	use/stage2/fs use/stage2/hid use/stage2/md \
	use/stage2/mmc use/stage2/net use/stage2/net-nfs \
	use/stage2/rtc use/stage2/sbc use/stage2/scsi use/stage2/usb
	@$(call try,SAVE_PROFILE,yes)
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call set,BOOTLOADER,grubpcboot)
endif

# base target (for most images)
distro/.regular-base: distro/.regular-bare use/vmguest use/memtest +efi; @:

# graphical target (not enforcing xorg drivers or blobs)
distro/.regular-x11: distro/.regular-base mixin/regular-x11 \
	use/x11/wacom use/x11/amdgpu +wireless \
	use/stage2/cifs use/live/x11 use/live/repo \
	use/live/suspend use/browser/firefox/live \
	use/syslinux/ui/gfxboot use/grub/ui/gfxboot
	@$(call add,THE_BRANDING,bootloader)
	@$(call add,THE_LISTS,$(call tags,(base || desktop) && regular))
	@$(call add,LIVE_LISTS,$(call tags,base rescue))
	@$(call add,LIVE_PACKAGES,gpm)
	@$(call add,DEFAULT_SERVICES_DISABLE,gpm powertop)

# WM base target
distro/.regular-wm: distro/.regular-x11 \
	mixin/regular-desktop +vmguest \
	use/live/rw use/live/install
	@$(call add,LIVE_PACKAGES,livecd-install-apt-cache)

# DE base target
# TODO: use/plymouth/live when luks+plymouth is done, see also #28255
distro/.regular-desktop: distro/.regular-wm use/branding/full \
	use/firmware/laptop +systemd +systemd-optimal; @:

distro/.regular-gtk: distro/.regular-desktop use/x11/lightdm/gtk +plymouth; @:

distro/.regular-desktop-sysv: distro/.regular-wm use/init/sysv/polkit; @:

distro/.regular-gtk-sysv: distro/.regular-desktop-sysv \
	use/syslinux/ui/gfxboot use/x11/gdm2.20; @:

distro/.regular-install: distro/.regular-base +installer \
	use/branding use/bootloader/grub use/luks use/stage2/kms \
	use/install2/fs use/install2/vnc use/install2/repo
	@$(call add,INSTALL2_PACKAGES,fdisk)
	@$(call add,INSTALL2_PACKAGES,xorg-conf-synaptics)
	@$(call add,THE_LISTS,$(call tags,base regular))
	@$(call add,INSTALL2_BRANDING,alterator notes)
	@$(call add,THE_BRANDING,alterator)

# common base for the very bare distros
distro/.regular-jeos-base: distro/.regular-bare \
	use/isohybrid use/branding \
	use/install2/repo use/install2/packages \
	use/net/etcnet use/power/acpi/button
	@$(call set,BOOTVGA,)
	@$(call set,INSTALLER,altlinux-generic)
	@$(call add,INSTALL2_BRANDING,alterator notes)
	@$(call add,THE_BRANDING,alterator) # just to be cleaned up later on
	@$(call add,THE_PACKAGES,apt basesystem dhcpcd vim-console su agetty)
	@$(call add,THE_LISTS,openssh)

# ...and for somewhat bare distros
distro/.regular-jeos: distro/.regular-jeos-base use/stage2/kms \
	use/install2/cleanup/everything use/install2/cleanup/kernel/everything \
	use/syslinux/lateboot.cfg use/cleanup/jeos
	@$(call add,BASE_PACKAGES,make-initrd-mdadm cpio)

distro/.regular-jeos-full: distro/.regular-jeos \
	use/volumes/jeos use/ntp/chrony use/bootloader/grub +efi
	@$(call add,BASE_PACKAGES,nfs-utils gdisk)
	@$(call add,INSTALL2_PACKAGES,fdisk)
ifeq (,$(filter-out e2k%,$(ARCH)))
	@$(call add,CLEANUP_PACKAGES,acpid-events-power)
else
	@$(call add,MAIN_PACKAGES,firmware-linux)
	@$(call add,CLEANUP_PACKAGES,libffi 'libltdl*')
	@$(call add,CLEANUP_PACKAGES,bridge-utils)
	@$(call set,KFLAVOURS,std-def)
endif
	@$(call add,DEFAULT_SERVICES_DISABLE,fbsetfont)
	@$(call add,BASE_KMODULES,drm)

# NB:
# - stock cleanup is not enough (or installer-common-stage3 deps soaring)
distro/regular-jeos-sysv: distro/.regular-jeos-full use/cleanup/jeos/full \
	+sysvinit
	@$(call add,BASE_PACKAGES,apt-conf-ignore-systemd)

distro/regular-jeos-systemd: distro/.regular-jeos-full \
	+systemd +systemd-optimal
	@$(call add,BASE_PACKAGES,glibc-locales)

ifeq (,$(filter-out i586 x86_64,$(ARCH)))
# NB: no +efi as it brings in grub2 (no ELILO support for system boot)
distro/regular-jeos-ovz: distro/.regular-jeos use/cleanup/jeos/full +sysvinit \
	use/server/ovz-base use/control/server/ldv use/firmware use/bootloader/lilo
	@$(call add,THE_PACKAGES,ipmitool lm_sensors3 mailx)
endif

distro/.regular-install-x11: distro/.regular-install +vmguest +wireless \
	use/install2/suspend mixin/regular-desktop mixin/regular-x11 \
	use/branding/complete use/branding/slideshow/once
	@$(call set,INSTALLER,altlinux-desktop)

# assumes somewhat more experienced user
distro/.regular-install-x11-full: distro/.regular-install-x11 \
	use/fonts/otf/adobe use/fonts/otf/mozilla use/fonts/chinese \
	mixin/desktop-installer use/install2/fs use/efi/shell use/rescue/base
	@$(call add,RESCUE_LISTS,$(call tags,rescue misc))
	@$(call add,MAIN_PACKAGES,anacron man-whatis usb-modeswitch)

distro/regular-icewm-sysv: distro/.regular-gtk-sysv mixin/regular-icewm \
	use/kernel/latest; @:

# wdm can't do autologin so add standalone one for livecd
distro/regular-wmaker-sysv: distro/.regular-desktop-sysv \
	mixin/regular-wmaker use/live/autologin
	@$(call add,LIVE_PACKAGES,wdm wmxkbru)

distro/regular-gnustep-sysv: distro/.regular-desktop-sysv \
	mixin/regular-wmaker mixin/regular-gnustep; @:
distro/regular-gnustep-systemd: distro/.regular-wm +systemd \
	mixin/regular-wmaker mixin/regular-gnustep; @:

distro/regular-xfce: distro/.regular-gtk mixin/regular-xfce use/kernel/latest;@:

distro/regular-xfce-sysv: distro/.regular-gtk-sysv mixin/regular-xfce-sysv; @:

distro/regular-xfce-sysv-install: distro/.regular-install-x11-full \
	mixin/regular-xfce-sysv use/init/sysv/polkit use/x11/gdm2.20; @:

distro/regular-lxde: distro/.regular-gtk mixin/regular-lxde; @:

distro/regular-xmonad: distro/.regular-gtk use/x11/xmonad
	@$(call add,LIVE_PACKAGES,livecd-regular-xmonad)

distro/regular-mate: distro/.regular-gtk mixin/regular-mate; @:

distro/regular-enlightenment: distro/.regular-gtk use/x11/enlightenment +power; @:

distro/regular-cinnamon: distro/.regular-gtk mixin/regular-cinnamon; @:

# not .regular-gtk due to gdm vs lightdm
distro/regular-gnome3: distro/.regular-desktop mixin/regular-gnome3 \
	use/kernel/latest +plymouth
	@$(call add,LIVE_PACKAGES,livecd-gnome3-setup-done)
	@$(call add,LIVE_PACKAGES,gnome-flashback screenpen)

distro/regular-lxqt: distro/.regular-gtk mixin/regular-lxqt +plymouth
	@$(call add,THE_LISTS,$(call tags,lxqt desktop))

distro/regular-deepin: distro/.regular-gtk use/x11/deepin
	@$(call add,THE_PACKAGES,deepin-regular)

distro/regular-kde5: distro/.regular-desktop \
	mixin/regular-kde5 use/domain-client use/x11/sddm +plymouth; @:

distro/regular-robo: distro/regular-mate +robotics use/live/ru; @:

distro/regular-rescue: distro/.regular-base mixin/regular-rescue  \
	use/rescue/rw use/efi/shell use/efi/memtest86 \
	use/hdt use/syslinux/rescue_fm.cfg use/syslinux/rescue_remote.cfg \
	use/grub/rescue_fm.cfg use/grub/rescue_remote.cfg \
	use/mediacheck use/stage2/kms use/kernel/latest +wireless
	@$(call add,RESCUE_PACKAGES,gpm livecd-net-eth)
	@$(call add,RESCUE_LISTS,$(call tags,base bench))
	@$(call add,RESCUE_LISTS,$(call tags,network security))
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call set,BOOTLOADER,isolinux)
endif

distro/regular-rescue-netbootxyz: distro/.regular-bare mixin/regular-rescue
	@$(call set,RELNAME,en.altlinux.org/rescue (netboot.xyz edition))
	@$(call set,META_VOL_ID,ALT Rescue)
	@$(call set,META_APP_ID,$(ARCH))

distro/.regular-server-base: distro/.regular-install use/server/base
	@$(call add,THE_LISTS,$(call tags,server && (regular || network)))
	@$(call set,INSTALLER,altlinux-server)
	@$(call add,SYSTEM_PACKAGES,multipath-tools)
	@$(call add,INSTALL2_PACKAGES,installer-feature-multipath)

distro/.regular-server: distro/.regular-server-base \
	use/server/mini use/firmware/qlogic use/rescue/base \
	use/ntp/chrony use/cleanup/libs use/bootloader/grub +efi
	@$(call add,RESCUE_LISTS,$(call tags,rescue misc))
	@$(call add,BASE_PACKAGES,aptitude)
	@$(call add,CLEANUP_PACKAGES,qt4-common qt5-base-common)
	@$(call add,DEFAULT_SERVICES_DISABLE,bridge)
	@$(call add,DEFAULT_SERVICES_ENABLE,getty@tty1)

distro/.regular-server-managed: distro/.regular-server
	@$(call add,THE_PACKAGES,alterator-fbi)
	@$(call add,THE_LISTS,$(call tags,server alterator))
	@$(call add,INSTALL2_PACKAGES,ntfs-3g)
	@$(call add,DEFAULT_SERVICES_DISABLE,ahttpd alteratord)

distro/.regular-server-full: distro/.regular-server-managed \
	use/server/groups/base use/dev/groups/builder use/install2/vnc/full
	@$(call add,MAIN_GROUPS,server/sambaDC)
	@$(call add,MAIN_GROUPS,tools/hyperv)
	@$(call add,BASE_KMODULES,staging)

distro/regular-server-systemd: distro/.regular-server-full \
	+systemd +systemd-optimal; @:

distro/regular-server-sysv: distro/.regular-server-full +sysvinit; @:

distro/.regular-server-ovz: distro/.regular-server \
	use/server/ovz use/server/groups/tools use/cleanup/x11-alterator
	@$(call add,MAIN_GROUPS,tools/vzstats)

distro/regular-server-ovz: distro/.regular-server-ovz +systemd; @:
distro/regular-server-ovz-sysv: distro/.regular-server-ovz +sysvinit; @:

distro/regular-server-hyperv: distro/.regular-server-managed \
	use/kernel/latest +systemd
	@$(call add,THE_PACKAGES,hyperv-daemons)
	@$(call add,DEFAULT_SERVICES_DISABLE,bridge smartd)
	@$(call add,DEFAULT_SERVICES_DISABLE,cpufreq-simple powertop)

distro/regular-server-pve: distro/.regular-server-base +systemd \
	use/kernel/server use/firmware/qlogic
	@$(call set,INSTALLER,altlinux-server)
	@$(call add,INSTALL2_PACKAGES,installer-feature-pve)
	@$(call add,THE_PACKAGES,pve-manager nfs-clients su)
	@$(call add,THE_PACKAGES,bridge-utils dhcpcd faketime tzdata postfix)
	@$(call add,DEFAULT_SERVICES_DISABLE,pve-manager pve-cluster \
		pve-firewall pve-ha-crm pve-manager pveproxy pvedaemon \
		pvefw-logger pve-ha-lrm pvenetcommit pvestatd spiceproxy)

distro/regular-builder: distro/.regular-bare mixin/regular-builder \
	use/dev/builder/full use/stage2/kms +sysvinit +efi +power \
	use/live/base use/live/rw use/live/repo/online use/live/textinstall \
	use/isohybrid use/syslinux/timeout/300 use/grub/timeout/30 use/stage2/net-eth
	@$(call add,THE_PACKAGES,ccache cifs-utils wodim)

distro/regular-server-samba4: distro/.regular-server-managed +systemd
	@$(call add,THE_LISTS,$(call tags,server && (sambaDC || alterator)))
	@$(call add,THE_PACKAGES,alterator-dhcp)
	@$(call add,DEFAULT_SERVICES_DISABLE,smbd nmbd winbind)

distro/regular-server-lxd: distro/.regular-bare \
	use/isohybrid +power \
	use/live/base use/live/rw use/live/repo/online use/live/textinstall \
	use/lxc/lxd use/tty/S0 use/init/systemd/multiuser use/kernel/latest
	@$(call add,DEFAULT_SERVICES_ENABLE,sshd)
	@$(call add,DEFAULT_SERVICES_ENABLE,lxd-startup lxd-bridge lxcfs cgmanager)
	@$(call add,DEFAULT_SERVICES_ENABLE,getty@tty1 getty@ttyS0)
	@$(call add,DEFAULT_SERVICES_ENABLE,livecd-net-eth)

endif

ifeq (ve,$(IMAGE_CLASS))
ve/docker-sisyphus: ve/docker; @:
endif
