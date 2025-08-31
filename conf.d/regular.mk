# regular build/usage images
ifeq (distro,$(IMAGE_CLASS))

distro/.regular-initrd:: use/stage2/ata use/stage2/fs use/stage2/hid \
	use/stage2/mmc use/stage2/scsi use/stage2/usb; @:

ifneq (,$(filter-out i586,$(ARCH)))
distro/.regular-initrd:: use/stage2/net use/stage2/net-nfs use/stage2/cifs \
	use/stage2/rtc use/stage2/sbc ; @:
endif

ifneq (,$(filter-out i586 x86_64,$(ARCH)))
distro/.regular-initrd:: use/stage2/drm ; @:
endif

# common ground (really lowlevel)
distro/.regular-bare: distro/.base use/kernel/net use/docs/license \
	distro/.regular-initrd use/tty use/bootloader/os-prober
	@$(call try,SAVE_PROFILE,yes)
	@$(call add,STAGE1_PACKAGES,firmware-linux)
	@$(call add,STAGE1_KMODULES,drm)
	@$(call set,BOOTVGA,)
	@$(call add,BASE_LISTS,openssh)

# base target (for most images)
distro/.regular-base: distro/.regular-bare use/vmguest use/memtest \
	use/efi/shell use/efi/dtb +efi \
	use/luks use/volumes/regular; @:

# Network install
ifeq (,$(filter-out i586 x86_64 aarch64 riscv64 loongarch64,$(ARCH)))
distro/regular-net-install: distro/grub-net-install use/grub/safe-mode.cfg use/tty; @:
ifeq (sisyphus,$(BRANCH))
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call set,BOOTCHAIN_OEM_URL_NETINST,/sisyphus/snapshots/$(DATE)/regular-NAME-$(DATE)-$(ARCH).iso)
else
	@$(call set,BOOTCHAIN_OEM_URL_NETINST,/sisyphus-$(ARCH)/snapshots/$(DATE)/regular-NAME-$(DATE)-$(ARCH).iso)
endif
endif
endif

# DE base target
distro/.regular-desktop-base: distro/.regular-base use/branding/full \
	mixin/regular-desktop mixin/regular-desktop-install +wireless \
	use/live/rw use/live/x11 use/live/repo use/vmguest/kvm \
	use/live/suspend use/grub/ui/gfxboot
	@$(call add,THE_BRANDING,bootloader)
	@$(call add,LIVE_PACKAGES,livecd-rescue-base-utils)
	@$(call set,GRUB_DEFAULT,live)
	@$(call set,SYSLINUX_DEFAULT,live)

distro/.regular-desktop: distro/.regular-desktop-base use/x11/wacom +vmguest \
	+systemd +plymouth; @:

# common base for the very bare distros
distro/.regular-jeos-base: distro/.regular-bare use/fonts/system +efi \
	use/branding +live-installer-pkg use/live-install/repo
	@$(call add,THE_BRANDING,alterator notes)
	@$(call add,BASE_PACKAGES,installer-common-stage3)
	@$(call add,LIVE_PACKAGES,alterator-net-functions) # for run scripts from installer-common-stage3
	@$(call add,THE_PACKAGES,apt basesystem dhcpcd vim-console su agetty)
	@$(call add,THE_PACKAGES,tzdata)
	@$(call add,BASE_PACKAGES,make-initrd-lvm make-initrd-mdadm cpio)
	@$(call add,BASE_LISTS,openssh)
	@$(call add,THE_PACKAGES,fdisk)
	@$(call add,THE_PACKAGES,btrfs-progs)
	@$(call set,LOCALES,en_US ru_RU)
	@$(call set,DISABLE_LANG_MENU,1)
ifeq (,$(filter-out p10,$(BRANCH)))
	@$(call add,THE_PACKAGES,glibc-locales)
endif

distro/.regular-jeos: distro/.regular-jeos-base use/cleanup \
	use/volumes/regular use/ntp/chrony use/net/etcnet \
	use/firmware use/drm use/vmguest \
	use/grub/safe-mode.cfg
	@$(call set,INSTALLER,jeos)
	@$(call add,CLEANUP_BASE_PACKAGES,alterator)
	@$(call add,BASE_PACKAGES,nfs-utils gdisk apt-repo)
	@$(call add,MAIN_PACKAGES,wpa_supplicant)

distro/regular-jeos-sysv: distro/.regular-jeos +sysvinit +power; @:

distro/regular-jeos-systemd: distro/.regular-jeos +systemd; @:
ifneq (,$(filter-out p10,$(BRANCH)))
	@$(call add,LIVE_PACKAGES,livecd-net-eth)
endif

distro/regular-icewm: distro/.regular-desktop-base use/x11/lightdm/gtk \
	mixin/regular-icewm
	@$(call add,THE_PACKAGES,icewm-startup-polkit-gnome)

distro/regular-icewm-sysv: distro/.regular-desktop-base mixin/regular-icewm \
	use/live/autologin +sysvinit-desktop; @:

# wdm can't do autologin so add standalone one for livecd
distro/regular-wmaker-sysv: distro/.regular-desktop-base \
	mixin/regular-wmaker use/live/autologin +sysvinit-desktop
	@$(call add,LIVE_PACKAGES,wmxkbru)

distro/regular-gnustep-sysv: distro/regular-wmaker-sysv \
	mixin/regular-gnustep; @:

distro/regular-gnustep: distro/.regular-desktop use/x11/lightdm/gtk \
	mixin/regular-wmaker mixin/regular-gnustep
	@$(call add,THE_PACKAGES,wmaker-autostart-polkit-gnome)

distro/regular-xfce: distro/.regular-desktop mixin/regular-xfce; @:

distro/regular-lxde: distro/.regular-desktop use/x11/lightdm/gtk \
	mixin/regular-lxde; @:

distro/regular-mate: distro/.regular-desktop mixin/regular-mate; @:

distro/regular-enlightenment: distro/.regular-desktop use/x11/enlightenment; @:

distro/regular-cinnamon: distro/.regular-desktop mixin/regular-cinnamon; @:

distro/regular-gnome: distro/.regular-desktop mixin/regular-gnome \
	+plymouth use/browser/epiphany \
	use/live-install/vnc/listen; @:

distro/regular-lxqt: distro/.regular-desktop mixin/regular-lxqt +plymouth; @:

distro/regular-kde: distro/.regular-desktop +nm \
	mixin/regular-kde +plymouth; @:

distro/regular-rescue: distro/.regular-base mixin/regular-rescue use/rescue/rw \
	use/hdt use/syslinux/rescue_fm.cfg use/syslinux/rescue_remote.cfg \
	use/grub/rescue_fm.cfg use/grub/rescue_remote.cfg \
	use/mediacheck use/stage2/kms +wireless
	@$(call add,RESCUE_PACKAGES,gpm livecd-net-eth)
	@$(call add,RESCUE_LISTS,$(call tags,network security))

distro/regular-rescue-live: distro/.regular-base +systemd \
	use/live/rescue/extra use/live/rescue/rw \
	use/stage2/kms use/hdt use/firmware/full \
	use/cleanup/live-no-cleanupdb use/live/repo +wireless +nm \
	use/syslinux/sdab.cfg use/grub/sdab_bios.cfg \
	use/deflogin use/ntp/chrony
	@$(call set,ROOTPW_EMPTY,1)
	@$(call add,LIVE_LISTS,openssh)
	@$(call add,LIVE_LISTS,$(call tags,network security))

distro/regular-rescue-netbootxyz: distro/.regular-bare mixin/regular-rescue
	@$(call set,RELNAME,en.altlinux.org/rescue (netboot.xyz edition))
	@$(call set,META_VOL_ID,ALT Rescue)
	@$(call set,META_APP_ID,$(ARCH))

distro/.regular-server-base: distro/.regular-jeos-base use/server/base
	@$(call add,BASE_LISTS,$(call tags,server && (regular || network)))
	@$(call add,SYSTEM_PACKAGES,multipath-tools)
	@$(call add,LIVE_PACKAGES,installer-feature-multipath)

distro/.regular-server: distro/.regular-server-base use/net/etcnet \
	use/server/mini use/firmware/qlogic \
	use/ntp/chrony use/bootloader/grub +efi \
	use/volumes/regular
	@$(call add,DEFAULT_SERVICES_DISABLE,bridge)
	@$(call add,DEFAULT_SERVICES_ENABLE,getty@tty1)

distro/.regular-server-managed: distro/.regular-server
	@$(call add,BASE_PACKAGES,alterator-fbi)
	@$(call add,BASE_LISTS,$(call tags,server alterator))
	@$(call add,LIVE_PACKAGES,ntfs-3g)
	@$(call add,DEFAULT_SERVICES_DISABLE,ahttpd alteratord)

distro/.regular-server-full: distro/.regular-server-managed \
	use/server/groups/base use/dev/groups/builder use/live-install/vnc/full
	@$(call add,MAIN_GROUPS,server/sambaDC)
	@$(call add,MAIN_GROUPS,tools/hyperv)
	@$(call add,BASE_KMODULES,staging)

distro/regular-server-systemd: distro/.regular-server-full \
	+systemd; @:
ifneq (,$(filter-out p10,$(BRANCH)))
	@$(call add,LIVE_PACKAGES,livecd-net-eth)
endif

distro/regular-server-sysv: distro/.regular-server-full +sysvinit +power; @:

distro/.regular-builder: distro/.regular-base mixin/regular-builder \
	use/stage2/kms use/firmware +power \
	use/live/base use/live/rw use/live/repo use/live/textinstall \
	use/isohybrid use/syslinux/timeout/300 use/grub/timeout/30
	@$(call add,THE_PACKAGES,ccache cifs-utils wodim)
	@$(call set,LIVE_NAME,ALT Builder $(BRANCH) Live)

distro/regular-builder: distro/.regular-builder +systemd +nm \
	use/dev/builder/live/systemd
	@$(call add,THE_PACKAGES,NetworkManager-tui)

# old regular-builder
distro/regular-builder-sysv: distro/.regular-builder +sysvinit \
	use/dev/builder/live/sysv
	@$(call add,THE_PACKAGES,livecd-net-eth)
	@$(call add,DEFAULT_SERVICES_ENABLE,gpm)
endif
