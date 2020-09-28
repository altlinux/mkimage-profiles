# desktop distributions
ifeq (distro,$(IMAGE_CLASS))

mixin/kworkstation-common-deps: \
	use/kernel/desktop use/kernel/net use/kernel/laptop \
	use/live/x11 use/live use/live/sound use/live/repo/online \
	use/syslinux/ui/gfxboot use/plymouth/full \
	use/efi/refind use/efi/shell \
	use/x11/xorg \
	use/branding/complete \
	use/firmware/wireless use/firmware/laptop use/firmware/cpu use/wireless/full \
	use/vmguest/complete use/vmguest/vbox/x11 use/vmguest/vmware/x11 \
	use/power/acpi \
	use/luks \
	use/net-eth/dhcp use/net-ssh use/net/nm/nodelay \
	use/ntp/chrony \
	use/docs/full \
	use/xdg-user-dirs \
	use/l10n/default/ru_RU \
	use/control use/services \
	use/x11/3d use/x11/radeon use/x11/amdgpu use/x11/nvidia \
	use/x11/sddm \
	use/memtest \
	use/init/systemd/settings/optimal \
	use/cleanup/live-no-cleanupdb \
	+net-eth +wireless +pulse +plymouth +systemd-optimal +wireless +vmguest +efi +nm
#	use/x11/nvidia/optimus \

mixin/kworkstation-common-opts:
ifeq (,$(filter-out aarch64,$(ARCH)))
	@$(call add,INSTALL2_PACKAGES,installer-feature-cleanup-kernel-stage3)
	@$(call add,LIVE_PACKAGES,installer-feature-cleanup-kernel-stage3)
endif
	@$(call add,EFI_BOOTARGS,lang=ru_RU)
	@$(call add,STAGE1_MODLISTS,stage2-mmc)
	@$(call set,BRANDING,xalt-kworkstation)
	@$(call set,DOCS,alt-kworkstation)
	@$(call add,BASE_KMODULES,kvm virtualbox)
	@$(call add,THE_KMODULES,staging)
	@$(call add,BASE_PACKAGES,os-prober)
	@$(call add,BASE_PACKAGES,plymouth-plugin-label)
	@$(call add,THE_PACKAGES,pam-limits-desktop)
	@$(call add,THE_PACKAGES,systemd-presets-kdesktop)
	@$(call add,THE_PACKAGES,etcnet-defaults-desktop)
	@$(call add,THE_PACKAGES,btrfs-progs)
	@$(call set,INSTALL2_FONTS,fonts-ttf-google-croscore-arimo)
	@$(call set,SYSTEM_FONTS,fonts-ttf-dejavu)
	@$(call set,LIVECD_FONTS,fonts-ttf-dejavu)
	@$(call add,THE_PACKAGES,fonts-ttf-dejavu)
	@$(call add,THE_PACKAGES,fonts-ttf-google-droid-sans)
	@$(call add,THE_PACKAGES,fonts-ttf-google-droid-serif)
	@$(call add,THE_PACKAGES,fonts-ttf-google-droid-sans-mono)
	@$(call add,THE_PACKAGES,fonts-ttf-google-crosextra-caladea)
	@$(call add,THE_PACKAGES,fonts-ttf-google-crosextra-carlito)
	@$(call add,THE_PACKAGES,fonts-ttf-google-noto-sans-symbols)
	@$(call add,THE_LISTS,$(call tags,basesystem alterator))
	@$(call add,MAIN_LISTS,kworkstation/disk-install)
	@$(call add,THE_LISTS,tagged/desktop+xorg)
	@$(call add,THE_LISTS,tagged/xorg+misc)
	@$(call add,CONTROL,xdg-user-dirs:enabled)
	@$(call add,SERVICES_ENABLE,smb)
	@$(call add,SERVICES_ENABLE,nmb)
	@$(call add,SERVICES_ENABLE,postfix)
	@$(call add,SERVICES_ENABLE,crond)
	@$(call add,SERVICES_ENABLE,x11presetdrv)
	@$(call add,SERVICES_ENABLE,bluetooth)
	@$(call add,SERVICES_ENABLE,ModemManager)
	@$(call add,SERVICES_ENABLE,NetworkManager)
	@$(call add,SERVICES_DISABLE,NetworkManager-wait-online)
	@$(call add,SERVICES_ENABLE,autofs)
	@$(call add,SERVICES_ENABLE,fstrim.timer)
	@$(call add,SERVICES_ENABLE,org.cups.cupsd.socket)
	@$(call add,SERVICES_ENABLE,cups.socket)
	@$(call add,SERVICES_ENABLE,org.cups.cupsd.path)
	@$(call add,SERVICES_ENABLE,cups.path)
	@$(call add,SERVICES_ENABLE,cups-browsed.service)
	@$(call add,SERVICES_DISABLE,org.cups.cupsd.service)
	@$(call add,SERVICES_DISABLE,cups.service)
	@$(call add,SERVICES_ENABLE,rngd)
	@$(call add,SERVICES_ENABLE,alteratord ahttpd)
	@$(call add,SERVICES_DISABLE,sysreport)
	@$(call add,SERVICES_DISABLE,rescue-remote)
	@$(call add,SERVICES_DISABLE,nscd)
	@$(call add,SERVICES_DISABLE,lircd)
	@$(call add,SERVICES_DISABLE,openl2tp)
	@$(call add,SERVICES_DISABLE,slapd)
	@$(call add,CLEANUP_BASE_PACKAGES,'libwbclient-sssd')
	@$(call add,CLEANUP_PACKAGES,'^kernel-modules-drm-nouveau.*')
	@$(call set,META_VOL_SET,ALT)
	@$(call set,META_PUBLISHER,BaseALT Ltd)
	@$(call set,META_VOL_ID,ALT $(DISTRO_VERSION) Workstation K $(ARCH))
	@$(call set,META_APP_ID,ALT $(DISTRO_VERSION) Workstation K $(ARCH) $(shell date +%F))

mixin/kworkstation-install-deps: \
	distro/.installer mixin/desktop-installer \
	use/install2/suspend use/install2/net use/install2 use/install2/stage3 \
	use/install2/vmguest \
	+installer

mixin/kworkstation-install-opts:
	@$(call set,INSTALLER,centaurus)
	@$(call add,STAGE1_MODLISTS,stage2-ntfs)
	@$(call add,STAGE2_KMODULES,drm-nouveau)
	@$(call add,STAGE2_BOOTARGS,logo.nologo loglevel=3 udev.log-priority=3) # vga=current
	@$(call add,STAGE2_BOOTARGS,systemd.show_status=0)
	@$(call add,THE_PACKAGES,installer-feature-nfs-client-stage3)
	@$(call add,INSTALL2_PACKAGES,ntfs-3g)
	@$(call add,INSTALL2_PACKAGES,btrfs-progs)
	@$(call add,INSTALL2_PACKAGES,installer-feature-samba-usershares-stage2)
	@$(call add,INSTALL2_PACKAGES,installer-feature-samba-automount-stage2)
	@$(call add,INSTALL2_PACKAGES,installer-feature-weak-passwd)
	@$(call add,INSTALL2_PACKAGES,installer-feature-desktop-disable-remote-stage2)
	@$(call add,INSTALL2_PACKAGES,installer-feature-desktop-etcissue)
	@$(call add,INSTALL2_PACKAGES,installer-feature-kdesktop-tmpfs)
	@$(call add,INSTALL2_PACKAGES,installer-feature-kdesktop-services)
	@$(call add,INSTALL2_PACKAGES,installer-feature-vmservices)
	@$(call add,INSTALL2_PACKAGES,installer-feature-online-repo)
	@$(call add,INSTALL2_PACKAGES,installer-feature-set-tz)
	@$(call add,INSTALL2_PACKAGES,installer-feature-rootgtktheme-stage2)
	@$(call add,INSTALL2_PACKAGES,apt-scripts-nvidia)
	@$(call add,INSTALL2_PACKAGES,volumes-profile-kdesktop)
	@$(call add,INSTALL2_PACKAGES,udev-rules-ioschedulers)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-dri-nouveau xorg-drv-nouveau)
	@$(call add,MAIN_GROUPS,$(kworkstation_groups))
	@$(call add,BASE_PACKAGES,alterator-postinstall)
	@$(call add,BASE_PACKAGES,make-initrd-mdadm mdadm)
	@$(call add,BASE_PACKAGES,apt-scripts-nvidia)
	@$(call add,LIVE_LISTS,$(call tags,base rescue))
	@$(call add,LIVE_LISTS,$(call tags,rescue fs))
	@$(call add,LIVE_LISTS,$(call tags,rescue live))
	@$(call add,LIVE_LISTS,$(call tags,rescue x11 !extra))
	@$(call add,LIVE_LISTS,$(call tags,rescue crypto))
	@$(call add,LIVE_LISTS,sound/pulseaudio)
	@$(call add,LIVE_LISTS,kworkstation/live-rescue)
	@$(call add,THE_LISTS,kworkstation/kde5-base)
	@$(call add,SERVICES_ENABLE,sshd)
	@$(call set,META_VOL_ID,ALT $(DISTRO_VERSION) Workstation K Install $(ARCH))
	@$(call set,META_APP_ID,ALT $(DISTRO_VERSION) Workstation K Install $(ARCH) $(shell date +%F))

mixin/kworkstation-live-deps: \
	distro/.base use/rescue/base \
	use/x11/xorg use/x11-autostart \
	use/cleanup/live-no-cleanupdb \
	use/live/no-cleanup \
	+net-eth +vmguest

mixin/kworkstation-live-opts:
	@$(call add,BASE_LISTS, \
		$(call tags,(base || desktop) && (l10n || network)))
	@$(call add,EFI_BOOTARGS,live_rw)
	@$(call add,SYSLINUX_CFG,live_rw)
	@$(call add,SYSLINUX_CFG,live_rw_default)
	@$(call add,LIVE_LISTS,kworkstation/kde5-base)
	@$(call add,LIVE_LISTS,kworkstation/kde5)
	@$(call add,LIVE_LISTS,kworkstation/emulators)
	@$(call add,LIVE_LISTS,kworkstation/graphics-editing)
	@$(call add,LIVE_LISTS,kworkstation/printing)
	@$(call add,LIVE_LISTS,kworkstation/publishing)
	@$(call add,LIVE_LISTS,kworkstation/scanning)
	@$(call add,LIVE_LISTS,kworkstation/remote-desktop)
	@$(call add,LIVE_LISTS,kworkstation/sound-editing)
	@$(call add,LIVE_LISTS,kworkstation/video-editing)
	@$(call add,SERVICES_DISABLE,sshd)
	@$(call set,META_VOL_ID,ALT $(DISTRO_VERSION) Workstation K Live $(ARCH))
	@$(call set,META_APP_ID,ALT $(DISTRO_VERSION) Workstation K Live $(ARCH) $(shell date +%F))

distro/kworkstation-install: \
	kworkstation_groups = $(addprefix kworkstation/,\
	kde5 \
	games \
	emulators remote-desktop \
	printing scanning \
	video-editing sound-editing graphics-editing \
	z01-add-clients clients-ad clients-ipa clients-backup clients-cloud clients-monitor)

distro/kworkstation-install: \
	mixin/kworkstation-install-deps \
	mixin/kworkstation-common-deps \
	mixin/kworkstation-common-opts \
	mixin/kworkstation-install-opts

distro/kworkstation-live: \
	mixin/kworkstation-live-deps \
	mixin/kworkstation-common-deps \
	mixin/kworkstation-common-opts \
	mixin/kworkstation-live-opts

distro/kworkstation-install-undef: \
	distro/kworkstation-install
	@$(call set,KFLAVOURS,un-def)

distro/kworkstation-live-undef: \
	distro/kworkstation-live
	@$(call set,KFLAVOURS,un-def)

mixin/kworkstation-fsin-opts:
	@$(call add,THE_PACKAGES,libwbclient task-auth-ad-sssd)
	@$(call add,THE_PACKAGES,task-auth-freeipa task-auth-ldap-sssd)
	@$(call add,THE_PACKAGES,task-samba-dc bind-utils tdb-utils installer-feature-sambaDC-stage3)
	@$(call add,THE_PACKAGES,task-auth-ldap-sssd)
	@$(call add,THE_PACKAGES,kde5-autofs-shares krb5-ticket-watcher kde5-file-actions-gost)
	@$(call add,THE_PACKAGES,openssl-gost-engine)
	@$(call add,THE_PACKAGES,openvpn-gostcrypto openvpn-plugins-gostcrypto alterator-openvpn-server)
	@$(call add,THE_PACKAGES,alt-customize-branding)
	@$(call add,THE_PACKAGES,alterator-kiosk)
	@$(call add,SERVICES_ENABLE,kiosk)

distro/kworkstation-install-fsin: \
	distro/kworkstation-install \
	mixin/kworkstation-fsin-opts
	@$(call set,KFLAVOURS,std-def)

endif


#	@$(call add,RESCUE_BOOTARGS,nomodeset vga=0)
#	use/mediacheck \
#	use/domain-client/full \
