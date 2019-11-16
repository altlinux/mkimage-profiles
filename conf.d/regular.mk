# regular build/usage images
ifeq (distro,$(IMAGE_CLASS))

# common ground (really lowlevel)
distro/.regular-bare: distro/.base +net-eth use/kernel/net use/docs/license
	@$(call try,SAVE_PROFILE,yes)

# base target (for most images)
distro/.regular-base: distro/.regular-bare use/vmguest use/memtest +efi
	@$(call add,STAGE1_MODLISTS,stage2-mmc)

# graphical target (not enforcing xorg drivers or blobs)
distro/.regular-x11: distro/.regular-base \
	use/x11/wacom use/x11/amdgpu +vmguest +wireless \
	use/stage2/cifs use/live/rw use/live/x11 use/live/repo \
	use/live/install use/live/suspend use/browser/firefox/live
	@$(call add,LIVE_PACKAGES,livecd-install-apt-cache)
	@$(call add,LIVE_LISTS,$(call tags,base rescue))
	@$(call add,LIVE_PACKAGES,gpm livecd-install-apt-cache)
	@$(call add,DEFAULT_SERVICES_DISABLE,gpm powertop)
	@$(call add,EFI_BOOTARGS,live_rw)

# WM base target
distro/.regular-wm: distro/.regular-x11 mixin/regular-x11 \
	mixin/regular-desktop use/efi/refind
	@$(call add,THE_BRANDING,bootloader)

# DE base target
# TODO: use/plymouth/live when luks+plymouth is done, see also #28255
distro/.regular-desktop: distro/.regular-wm \
	use/syslinux/ui/gfxboot use/firmware/laptop +systemd-optimal
	@$(call add,THE_BRANDING,bootloader)
	@$(call add,THE_PACKAGES,installer-feature-desktop-other-fs-stage2)
	@$(call set,KFLAVOURS,std-def)

distro/.regular-gtk: distro/.regular-desktop use/x11/lightdm/slick +plymouth; @:
distro/.regular-sysv: distro/.regular-wm use/init/sysv/polkit; @:

distro/.regular-sysv-gtk: distro/.regular-sysv use/syslinux/ui/gfxboot \
	use/x11/gdm2.20; @:

distro/.regular-install: distro/.regular-base +installer +sysvinit +power \
	use/branding use/bootloader/grub use/luks \
	use/install2/fs use/install2/vnc use/install2/repo \
	use/efi/refind
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
	@$(call add,THE_PACKAGES,apt basesystem dhcpcd vim-console su agetty)
	@$(call add,THE_LISTS,openssh)

ifeq (,$(filter-out i586 x86_64,$(ARCH)))
distro/.regular-jeos-bootloader: use/bootloader/lilo ; @:
else
ifeq (,$(filter-out $(GRUB_ARCHES),$(ARCH)))
distro/.regular-jeos-bootloader: use/bootloader/grub ; @:
else
distro/.regular-jeos-bootloader: ; @:
endif
endif

# ...and for somewhat bare distros
distro/.regular-jeos: distro/.regular-jeos-base \
	distro/.regular-jeos-bootloader use/syslinux/lateboot.cfg \
	use/install2/cleanup/everything use/install2/cleanup/kernel/everything \
	use/cleanup/jeos
	@$(call add,BASE_KMODULES,guest scsi vboxguest)
	@$(call add,BASE_PACKAGES,make-initrd-mdadm cpio)

# NB:
# - stock cleanup is not enough (or installer-common-stage3 deps soaring)
distro/regular-jeos: distro/.regular-jeos use/cleanup/jeos/full \
	use/volumes/jeos use/install2/vmguest use/vmguest/bare
	@$(call add,BASE_PACKAGES,nfs-utils gdisk)
	@$(call add,MAIN_PACKAGES,firmware-linux)
	@$(call add,CLEANUP_PACKAGES,libffi 'libltdl*')
	@$(call add,CLEANUP_PACKAGES,bridge-utils)
	@$(call add,DEFAULT_SERVICES_DISABLE,fbsetfont)
	@$(call add,STAGE2_BOOTARGS,quiet)
	@$(call set,KFLAVOURS,un-def)

# NB: no +efi as it brings in grub2 (no ELILO support for system boot)
distro/regular-jeos-ovz: distro/.regular-jeos \
	use/server/ovz-base use/control/server/ldv use/firmware
	@$(call add,THE_PACKAGES,ipmitool lm_sensors3 mailx)

distro/.regular-install-x11: distro/.regular-install +vmguest +wireless \
	use/install2/suspend mixin/regular-desktop mixin/regular-x11
	@$(call set,INSTALLER,altlinux-desktop)

# assumes somewhat more experienced user, mostly for sysv variants
distro/.regular-install-x11-full: distro/.regular-install-x11 \
	mixin/desktop-installer mixin/regular-desktop use/install2/fs \
	use/fonts/otf/adobe use/fonts/otf/mozilla use/fonts/chinese \
	use/branding/complete use/branding/slideshow/once \
	use/net-eth/dhcp use/efi/shell use/rescue/base
	@$(call add,RESCUE_LISTS,$(call tags,rescue misc))
	@$(call add,MAIN_PACKAGES,anacron man-whatis usb-modeswitch)
	@$(call add,DEFAULT_SERVICES_ENABLE,alteratord)

distro/regular-icewm: distro/.regular-sysv-gtk mixin/regular-icewm \
	use/browser/chromium
	@$(call set,KFLAVOURS,un-def)

# wdm can't do autologin so add standalone one for livecd
distro/regular-wmaker: distro/.regular-sysv \
	mixin/regular-wmaker use/live/autologin
	@$(call add,LIVE_PACKAGES,wdm wmxkbru)

distro/regular-gnustep: distro/.regular-sysv \
	mixin/regular-wmaker mixin/regular-gnustep; @:
distro/regular-gnustep-systemd: distro/.regular-wm +systemd \
	mixin/regular-wmaker mixin/regular-gnustep; @:

distro/regular-xfce: distro/.regular-gtk mixin/regular-xfce; @:
	@$(call set,KFLAVOURS,un-def)

distro/regular-xfce-sysv: distro/.regular-sysv-gtk mixin/regular-xfce-sysv; @:

distro/regular-sysv-xfce: distro/.regular-install-x11-full \
	mixin/regular-xfce-sysv; @:

distro/regular-lxde: distro/.regular-gtk mixin/regular-lxde; @:
distro/regular-lxde-sysv: distro/.regular-sysv-gtk mixin/regular-lxde; @:

distro/regular-xmonad: distro/.regular-gtk use/x11/xmonad
	@$(call add,LIVE_PACKAGES,livecd-regular-xmonad)

distro/regular-mate: distro/.regular-gtk mixin/regular-mate; @:

distro/regular-mate-sysv: distro/.regular-sysv-gtk mixin/mate-base; @:

distro/regular-enlightenment: distro/.regular-gtk use/x11/enlightenment; @:

distro/regular-enlightenment-sysv: distro/.regular-sysv-gtk \
	use/x11/enlightenment
	@$(call set,META_VOL_ID,ALT regular-E-SysV/$(ARCH)) # see also #28271

distro/regular-cinnamon: distro/.regular-gtk mixin/regular-cinnamon; @:

# not .regular-gtk due to gdm vs lightdm
distro/regular-gnome3: distro/.regular-desktop +plymouth +nm-gtk \
	use/x11/gnome3 use/fonts/ttf/redhat
	@$(call set,KFLAVOURS,un-def)
	@$(call add,LIVE_PACKAGES,livecd-gnome3-setup-done)
	@$(call add,LIVE_PACKAGES,gnome3-regular xcalib templates)
	@$(call add,LIVE_PACKAGES,gnome-flashback screenpen)
	@$(call add,LIVE_PACKAGES,chrome-gnome-shell)
	@$(call add,LIVE_PACKAGES,firefox-gnome_shell_integration)

distro/regular-lxqt: distro/.regular-desktop mixin/regular-lxqt +plymouth \
	use/browser/falkon use/x11/sddm
	@$(call add,THE_LISTS,$(call tags,lxqt desktop))

distro/regular-lxqt-sysv: distro/.regular-sysv mixin/regular-lxqt \
	use/net-eth/dhcp; @:

distro/regular-kde5: distro/.regular-desktop \
	mixin/regular-kde5 use/domain-client use/x11/sddm +plymouth; @:

distro/regular-robo: distro/regular-mate +robotics use/live/ru; @:

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

distro/.regular-server-base: distro/.regular-install \
	use/server/base use/stage2/kms
	@$(call add,THE_LISTS,$(call tags,server && (regular || network)))
	@$(call set,INSTALLER,altlinux-server)
	@$(call add,SYSTEM_PACKAGES,multipath-tools)
	@$(call add,INSTALL2_PACKAGES,installer-feature-multipath)

distro/.regular-server-systemd: distro/.regular-server-base +systemd; @:

distro/.regular-server: distro/.regular-server-base \
	use/server/mini use/firmware/qlogic use/rescue/base \
	use/ntp/client use/cleanup/libs
	@$(call add,RESCUE_LISTS,$(call tags,rescue misc))
	@$(call add,MAIN_PACKAGES,aptitude)
	@$(call add,CLEANUP_PACKAGES,qt4-common qt5-base-common)
	@$(call add,DEFAULT_SERVICES_DISABLE,bridge)

distro/.regular-server-managed: distro/.regular-server
	@$(call add,THE_PACKAGES,alterator-fbi)
	@$(call add,THE_LISTS,$(call tags,server alterator))
	@$(call add,INSTALL2_PACKAGES,ntfs-3g)
	@$(call add,DEFAULT_SERVICES_DISABLE,ahttpd alteratord)

distro/regular-server: distro/.regular-server-managed \
	use/server/groups/base use/dev/groups/builder use/install2/vnc/full
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

distro/regular-server-pve: distro/.regular-server-systemd \
	use/kernel/server use/firmware/qlogic +efi
	@$(call set,BASE_BOOTLOADER,grub)
	@$(call set,INSTALLER,altlinux-server)
	@$(call add,INSTALL2_PACKAGES,installer-feature-pve)
	@$(call add,THE_PACKAGES,pve-manager nfs-clients su)
	@$(call add,THE_PACKAGES,bridge-utils dhcpcd faketime tzdata postfix)
	@$(call add,DEFAULT_SERVICES_DISABLE,pve-manager pve-cluster \
		pve-firewall pve-ha-crm pve-manager pveproxy pvedaemon \
		pvefw-logger pve-ha-lrm pvenetcommit pvestatd spiceproxy)

distro/regular-builder: distro/.regular-bare mixin/regular-builder \
	use/dev/builder/full +sysvinit +efi +power \
	use/live/base use/live/rw use/live/repo/online use/live/textinstall \
	use/isohybrid use/syslinux/timeout/30 use/stage2/net-eth
	@$(call add,THE_PACKAGES,ccache cifs-utils wodim)

distro/regular-server-samba4: distro/.regular-server-managed
	@$(call add,THE_LISTS,$(call tags,server && (sambaDC || alterator)))
	@$(call add,THE_PACKAGES,alterator-dhcp)
	@$(call add,DEFAULT_SERVICES_DISABLE,smbd nmbd winbind)

distro/regular-server-lxd: distro/.regular-bare \
	use/isohybrid +power \
	use/live/base use/live/rw use/live/repo/online use/live/textinstall \
	use/lxc/lxd use/tty/S0 \
	use/init/systemd/multiuser
	@$(call set,KFLAVOURS,un-def)
	@$(call add,DEFAULT_SERVICES_ENABLE,sshd)
	@$(call add,DEFAULT_SERVICES_ENABLE,lxd-startup lxd-bridge lxcfs cgmanager)
	@$(call add,DEFAULT_SERVICES_ENABLE,getty@tty1 getty@ttyS0)
	@$(call add,DEFAULT_SERVICES_ENABLE,livecd-net-eth)

distro/regular-engineering: distro/regular-lxde use/live/ru \
	use/office/LibreOffice/gtk3 use/office/LibreOffice/lang \
	use/office/LibreOffice/still
	@$(call add,THE_LISTS,engineering/2d-cad)
	@$(call add,THE_LISTS,engineering/3d-cad)
	@$(call add,THE_LISTS,engineering/3d-printer)
	@$(call add,THE_LISTS,engineering/eda)
	@$(call add,THE_LISTS,engineering/cam)
	@$(call add,THE_LISTS,engineering/cnc)
	@$(call add,THE_LISTS,engineering/apcs)
	@$(call add,THE_LISTS,engineering/scada)

endif

ifeq (ve,$(IMAGE_CLASS))
ve/docker-sisyphus: ve/docker; @:
endif
