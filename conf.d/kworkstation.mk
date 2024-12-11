# desktop distributions
ifeq (distro,$(IMAGE_CLASS))

mixin/kworkstation-common-deps: \
	use/kernel/desktop use/kernel/net use/kernel/laptop \
	use/live/x11 use/live use/live/sound \
	use/live/rescue \
	use/syslinux/ui/gfxboot use/plymouth/full \
	use/efi/grub use/efi/shell \
	use/x11/xorg \
	use/branding/complete \
	use/firmware/wireless use/firmware/laptop use/firmware/cpu use/wireless/full \
	use/vmguest/complete use/vmguest/vbox/x11 use/vmguest/vmware/x11 \
	use/luks \
	use/net-eth/dhcp use/net-ssh use/net/nm/nodelay use/net/etcnet \
	use/ntp/chrony \
	use/docs/full \
	use/xdg-user-dirs \
	use/l10n/default/ru_RU \
	use/control use/services \
	use/x11/intel use/x11/radeon use/x11/amdgpu use/x11/nvidia \
	use/x11/kde-display-manager-lightdm use/x11/wacom \
	use/memtest \
	use/cleanup/live-no-cleanupdb \
	use/stage2/ata use/stage2/fs use/stage2/hid use/stage2/md \
	use/stage2/mmc use/stage2/net use/stage2/net-nfs use/stage2/cifs \
	use/stage2/rtc use/stage2/sbc use/stage2/scsi use/stage2/usb \
	use/alternatives/xvt/konsole \
	+wireless +pipewire +plymouth +systemd +systemd-optimal +wireless +vmguest +efi +nm \
	use/stage2/kms/nvidia; @:

mixin/kworkstation-common-opts:
	@$(call set,LOCALES,ru_RU be_BY en_US)
	@$(call set,BRANDING,xalt-kworkstation)
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call set,BOOTLOADER,grubpcboot)
endif
	@$(call set,GRUBTHEME,branding-xalt-kworkstation)
	@$(call set,DOCS,alt-kworkstation)
	@$(call add,PINNED_PACKAGES,systemd)
	@$(call try,THE_BROWSER,yandex-browser-stable)
	@$(call add,BASE_KMODULES,virtualbox)
	@$(call add,THE_KMODULES,staging)
	@$(call add,BASE_PACKAGES,os-prober)
	@$(call add,BASE_PACKAGES,plymouth-plugin-label)
	@$(call add,THE_PACKAGES,pam-limits-desktop)
	@$(call add,THE_PACKAGES,systemd-presets-kdesktop)
	@$(call add,THE_PACKAGES,systemd-oomd-defaults)
	@$(call add,THE_PACKAGES,etcnet-defaults-desktop)
	@$(call set,LIVECD_FONTS,fonts-ttf-google-noto-sans)
	@$(call add,THE_PACKAGES,fonts-ttf-dejavu)
	@$(call add,THE_PACKAGES,fonts-ttf-google-noto-sans)
	@$(call add,THE_PACKAGES,fonts-ttf-google-noto-serif)
	@$(call add,THE_PACKAGES,fonts-ttf-google-noto-sans-mono)
	@$(call add,THE_PACKAGES,fonts-ttf-google-crosextra-caladea)
	@$(call add,THE_PACKAGES,fonts-ttf-google-crosextra-carlito)
	@$(call add,THE_PACKAGES,fonts-otf-google-noto-sans-cjk-hk)
	@$(call add,THE_PACKAGES,fonts-otf-google-noto-sans-mono-cjk-hk)
	@$(call add,THE_PACKAGES,fonts-ttf-google-noto-sans-symbols)
	@$(call add,THE_PACKAGES,fonts-ttf-google-noto-sans-symbols2)
	@$(call add,THE_PACKAGES,fonts-ttf-material-icons)
	@$(call add,THE_PACKAGES,fonts-ttf-google-noto-emoji)
	@$(call add,THE_PACKAGES,fonts-ttf-google-noto-emoji-color)
	@$(call add,THE_LISTS,$(call tags,basesystem alterator))
	@$(call add,MAIN_LISTS,kworkstation/disk-install)
	@$(call add,THE_LISTS,tagged/desktop+xorg)
	@$(call add,THE_LISTS,tagged/xorg+misc)
	@$(call add,CONTROL,xdg-user-dirs:enabled)
	@$(call add,CONTROL,fusermount:wheelonly)
	@$(call add,CONTROL,libnss-role:enabled)
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
	@$(call add,SERVICES_ENABLE,snapd.socket)
	@$(call add,SERVICES_ENABLE,power-profiles-daemon.service)
	@$(call add,SERVICES_ENABLE,switcheroo-control)
	@$(call add,CLEANUP_BASE_PACKAGES,'libwbclient-sssd')
	@$(call add,CLEANUP_PACKAGES,'^kernel-modules-drm-nouveau.*')
	@$(call add,CLEANUP_PACKAGES,'xterm')
	@$(call add,CLEANUP_LIVE_PACKAGES,'xterm')
	@$(call add,CLEANUP_PACKAGES,'udev-rule-generator-net')
	@$(call add,CLEANUP_LIVE_PACKAGES,'livecd-main-repo')
	@$(call set,ISO_LEVEL,3)
	@$(call set,META_VOL_SET,ALT)
	@$(call set,META_PUBLISHER,BaseALT Ltd)
	@$(call set,META_VOL_ID,ALT Workstation K $(DISTRO_VERSION)$(STATUS))
	@$(call set,META_APP_ID,ALT Workstation K $(DISTRO_VERSION)$(STATUS) $(ARCH) $(shell date +%F))

mixin/kworkstation-install-deps: \
	distro/.base \
	use/x11/xorg use/x11-autostart \
	use/stage2/net-install-live \
	use/grub/localboot_bios.cfg \
	use/live-install/vnc/listen \
	use/live-install/suspend \
	use/live/no-cleanup \
	+net-eth +vmguest +live-installer-pkg; @:

mixin/kworkstation-install-opts:
	@$(call set,GRUB_DEFAULT,harddisk)
	@$(call set,INSTALLER,kworkstation)
	@$(call add,STAGE1_MODLISTS,stage2-ntfs)
	@$(call add,STAGE2_KMODULES,drm-nouveau)
	@$(call add,BASE_PACKAGES,installer-feature-nfs-client-stage3)
	@$(call add,BASE_PACKAGES,alt-welcome-k)
	@$(call add,LIVE_PACKAGES,installer-feature-samba-usershares-kde-stage2)
	@$(call add,LIVE_PACKAGES,installer-feature-samba-automount-stage2)
	@$(call add,LIVE_PACKAGES,installer-feature-weak-passwd)
	@$(call add,LIVE_PACKAGES,installer-feature-desktop-disable-remote-stage2)
	@$(call add,LIVE_PACKAGES,installer-feature-desktop-etcissue)
	@$(call add,LIVE_PACKAGES,installer-feature-kdesktop-tmpfs)
	@$(call add,LIVE_PACKAGES,installer-feature-kdesktop-services)
	@$(call add,LIVE_PACKAGES,installer-feature-vmservices)
	@$(call add,LIVE_PACKAGES,installer-feature-online-repo)
	@$(call add,LIVE_PACKAGES,installer-feature-set-tz)
	@$(call add,LIVE_PACKAGES,installer-feature-rootgtktheme-stage2)
	@$(call add,LIVE_PACKAGES,installer-feature-alterator-setup-stage2)
	@$(call add,LIVE_PACKAGES,installer-feature-packagekit-setup)
	@$(call add,LIVE_PACKAGES,installer-feature-xprofile-clear)
	@$(call add,LIVE_PACKAGES,installer-feature-systemd-oomd)
	@$(call add,LIVE_PACKAGES,installer-feature-webterminal-setup)
	@$(call add,LIVE_PACKAGES,installer-feature-remove-xorgconf)
	@$(call add,LIVE_PACKAGES,installer-feature-swapfile)
	@$(call add,LIVE_PACKAGES,apt-scripts-nvidia)
	@$(call add,LIVE_PACKAGES,volumes-profile-kdesktop)
	@$(call add,LIVE_PACKAGES,udev-rules-ioschedulers)
	@$(call add,LIVE_PACKAGES,passwdqc-utils)
	@$(call add,LIVE_PACKAGES,btrfs-progs)
	@$(call add,MAIN_GROUPS,$(kworkstation_groups))
	@$(call add,THE_PROFILES,kworkstation/10-workstation)
	@$(call add,THE_PROFILES,kworkstation/20-webterminal)
	@$(call add,BASE_PACKAGES,alterator-postinstall)
	@$(call add,BASE_PACKAGES,make-initrd-mdadm mdadm)
	@$(call add,BASE_PACKAGES,apt-scripts-nvidia)
	@$(call add,LIVE_LISTS,$(call tags,base rescue))
	@$(call add,LIVE_LISTS,$(call tags,rescue fs))
	@$(call add,LIVE_LISTS,$(call tags,rescue live))
	@$(call add,LIVE_LISTS,$(call tags,rescue x11))
	@$(call add,LIVE_LISTS,$(call tags,rescue extra))
	@$(call add,LIVE_LISTS,$(call tags,rescue crypto))
	@$(call add,LIVE_LISTS,kworkstation/live-rescue)
	@$(call add,LIVE_LISTS,kworkstation/printing)
	@$(call add,LIVE_LISTS,kworkstation/scanning)
	@$(call add,THE_LISTS,kworkstation/kde-base)
	@$(call add,SERVICES_ENABLE,sshd)

mixin/kworkstation-live-deps: \
	distro/.base \
	use/x11/xorg use/x11-autostart \
	use/live/no-cleanup \
	use/grub/live_rw.cfg \
	+net-eth +vmguest; @:

mixin/kworkstation-live-opts:
	@$(call add,BASE_LISTS, \
		$(call tags,(base || desktop) && (l10n || network)))
	@$(call add,GRUB_TIMEOUT,3)
	@$(call set,GRUB_DEFAULT,session)
	@$(call add,SYSLINUX_CFG,live_rw)
	@$(call set,SYSLINUX_DEFAULT,session)
	@$(call add,LIVE_LISTS,kworkstation/kde-base)
	@$(call add,LIVE_LISTS,kworkstation/kde)
	@$(call add,LIVE_LISTS,kworkstation/emulators)
	@$(call add,LIVE_LISTS,kworkstation/printing)
	@$(call add,LIVE_LISTS,kworkstation/graphics-editing)
	@$(call add,LIVE_LISTS,kworkstation/scanning)
	@$(call add,LIVE_LISTS,kworkstation/remote-desktop)
	@$(call add,LIVE_LISTS,kworkstation/sound-editing)
	@$(call add,LIVE_LISTS,kworkstation/video-editing)
	@$(call add,LIVE_LISTS,kworkstation/publishing)
	@$(call add,SERVICES_DISABLE,sshd)
	@$(call add,CLEANUP_LIVE_PACKAGES,'flatpak')
	@$(call add,CLEANUP_LIVE_PACKAGES,'snapd')
	@$(call set,META_VOL_ID,ALT Workstation K $(DISTRO_VERSION)$(STATUS) Live)
	@$(call set,META_APP_ID,ALT Workstation K $(DISTRO_VERSION)$(STATUS) Live $(ARCH) $(shell date +%F))

distro/kworkstation-install: \
	kworkstation_groups = $(addprefix kworkstation/,\
	kde games emulators printing scanning \
	z00-add-3dparty 3dparty-flatpak 3dparty-snap \
	z01-add-clients clients-ad clients-ipa clients-backup clients-cloud clients-monitor \
	z02-add-additional add-adm add-oem add-tablet add-webterminal add-no4k-screen)

distro/kworkstation-install: \
	mixin/kworkstation-install-deps \
	mixin/kworkstation-common-deps \
	mixin/kworkstation-common-opts \
	mixin/kworkstation-install-opts; @

distro/kworkstation-live: \
	mixin/kworkstation-live-deps \
	mixin/kworkstation-common-deps \
	mixin/kworkstation-common-opts \
	mixin/kworkstation-live-opts; @

mixin/kworkstation-fsin-opts:
	@$(call add,THE_PACKAGES,libwbclient task-auth-ad-sssd)
	@$(call add,THE_PACKAGES,task-auth-freeipa task-auth-ldap-sssd)
	@$(call add,THE_PACKAGES,task-samba-dc bind-utils tdb-utils installer-feature-sambaDC-stage3)
	@$(call add,THE_PACKAGES,task-auth-ldap-sssd)
	@$(call add,THE_PACKAGES,kde-autofs-shares krb5-ticket-watcher kde-file-actions-gost)
	@$(call add,THE_PACKAGES,openssl-gost-engine)
	@$(call add,THE_PACKAGES,openvpn-gostcrypto openvpn-plugins-gostcrypto alterator-openvpn-server)
	@$(call add,THE_PACKAGES,alt-customize-branding)
	@$(call add,THE_PACKAGES,alterator-kiosk kiosk-profiles)
	@$(call add,SERVICES_ENABLE,kiosk)

distro/kworkstation-install-fsin: \
	distro/kworkstation-install \
	mixin/kworkstation-fsin-opts; @:

endif


#	@$(call add,RESCUE_BOOTARGS,nomodeset vga=0)
#	use/mediacheck \
#	use/domain-client/full \
