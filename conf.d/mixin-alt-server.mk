mixin/alt-server: server_groups = $(addprefix centaurus/,\
	10-alterator 20-server-apps 50-freeipa 70-dev 801-grp-pol 901-net-if-mgt \
	sambaDC buildsystem dhcp-server-a diag-tools dns-server-a ftp-server-a \
	mail-server-a owncloud freeipa-client nm-daemon \
	systemd-networkd openuds openuds-tunnel admc gpupdate gptemplates)

mixin/alt-server: server_main_kmodules = bcmwl ch34x dm-secdel drbd9 drm-ancient \
	drm-nouveau drm e1000e hifc hinic i40e ide ipset ipt_netflow ipt-ratelimit \
	ipt-so ixgbe kvdo LiME linux-gpib lsadrv ndpi nvidia nxp-pn71xx-getmobit \
	promethean r8125 r8168 rtl8168 rtl8188fu rtl8192eu rtl8192fu rtl8723bu \
	rtl8812au rtl8821ce rtl8821cu rtl88x2bu rtw89 staging tripso usb-vhci \
	v4l2loopback vboxsf vhba virtualbox-addition-guest virtualbox-addition \
	virtualbox-addition-video virtualbox xtables-addons

mixin/alt-server: +systemd \
	+live-installer-pkg \
	use/live/rescue \
	use/live/repo \
	use/live/suspend \
	use/live-install/oem \
	use/live-install/vnc/listen \
	use/ntp/chrony \
	use/branding/notes \
	use/control use/services \
	use/volumes/alt-server \
	use/apt-conf/branch \
	use/fonts/install2 \
	use/l10n/default/ru_RU \
	use/firmware/full \
	use/net/etcnet \
	use/tty
	@$(call set,INSTALLER,centaurus)
	@$(call set,BRANDING,alt-server)
	@$(call set,GRUB_DIRECT,1)
	@$(call add,GRUB_CFG,defaults fwsetup_efi)
	@$(call set,THE_APT_CONF,branch-gostcrypto)
	@$(call set,DISABLE_LANG_MENU,in_grub)
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call set,BOOTLOADER,grubpcboot)
endif
	@$(call add,THE_BRANDING,alterator)
ifeq (,$(filter-out i586 x86_64 aarch64,$(ARCH)))
	@$(call set,KFLAVOURS,std-def un-def)
	@$(call add,LIVE_PACKAGES,installer-feature-cleanup-kernel-stage3)
	@$(call add,LIVE_PACKAGES,ntfs-3g)
	@$(call add,BASE_KMODULES,drm)
	@$(call add,MAIN_GROUPS,centaurus/proxmox-backup-server)
	@$(call add,MAIN_GROUPS,centaurus/token)
	@$(call add,MAIN_PACKAGES,mate-reduced-resource)
endif
ifeq (,$(filter-out loongarch64,$(ARCH)))
	@$(call set,THE_APT_CONF,sisyphus)
	@$(call set,KFLAVOURS,loongarch)
	@$(call add,MAIN_GROUPS,centaurus/token)
	@$(call add,MAIN_PACKAGES,mate-reduced-resource)
endif
	@$(call add,MAIN_KMODULES,$(server_main_kmodules))
	@$(call add,BASE_LISTS,centaurus/base)
	@$(call add,BASE_LISTS,centaurus/base-server)
	@$(call add,BASE_LISTS,centaurus/lsb-core)
	@$(call add,LIVE_LISTS,centaurus/live)
	@$(call add,MAIN_LISTS,centaurus/remmina)
	@$(call add,MAIN_LISTS,centaurus/cups)
	@$(call add,MAIN_LISTS,centaurus/nm)
	@$(call add,BASE_LISTS,centaurus/domain-client)
	@$(call add,MAIN_GROUPS,$(server_groups))
	@$(call add,MAIN_LISTS,centaurus/cppcheck)
	@$(call add,MAIN_LISTS,centaurus/disk)
	@$(call add,THE_PROFILES,centaurus-10-server)
	@$(call add,THE_PROFILES,centaurus-20-serverDC)
ifeq (,$(filter-out i586 x86_64 aarch64 loongarch64 e2k%,$(ARCH)))
	@$(call add,THE_PROFILES,centaurus-30-desktop)
endif
ifeq (,$(filter-out x86_64 ppc64le aarch64,$(ARCH)))
	@$(call add,THE_PROFILES,centaurus-40-docker)
endif
	@$(call add,THE_PROFILES,minimal)
	@$(call add,STAGE1_MODLISTS,stage2-mmc)
	@$(call add,LIVE_PACKAGES,installer-feature-multipath)
	@$(call add,LIVE_PACKAGES,installer-feature-alphabet-profiles)
	@$(call add,LIVE_PACKAGES,installer-feature-load-tun)
	@$(call add,LIVE_PACKAGES,installer-feature-network-shares-stage3)
	@$(call add,LIVE_PACKAGES,installer-feature-auto-domain)
ifneq (,$(filter-out e2k%,$(ARCH)))
	@$(call add,LIVE_PACKAGES,installer-feature-quota-stage2)
endif
ifeq (,$(filter-out x86_64,$(ARCH)))
	@$(call add,MAIN_GROUPS,centaurus/jitsi-meet)
endif
	@$(call add,LIVE_PACKAGES,fdisk)
	@$(call add,LIVE_PACKAGES,xorg-conf-synaptics)
	@$(call add,COMMON_PACKAGES,vim-console)
	@$(call add,DEFAULT_SERVICES_ENABLE,rpcbind sshd bind)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,systemd-networkd.service systemd-resolved.service)
	@$(call add,SYSTEMD_SERVICES_MASK,suspend.target hibernate.target)
	@$(call add,DEFAULT_SERVICES_ENABLE,alteratord ahttpd libvirtd qemu-kvm)
	@$(call add,DEFAULT_SERVICES_ENABLE,virtualbox openntpd bacula-fd daytime-tcp)
	@$(call add,DEFAULT_SERVICES_DISABLE,vz slapd smb httpd2 squid)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,lightdm.service)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,cups.service)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,avahi-daemon.service)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,NetworkManager.service)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,ModemManager.service postfix.service)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,sshd.service ahttpd.service)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,alteratord.service xinetd.service)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,nfs-server.service bind.service)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,cpufreq-simple.service)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,getty@tty1.service)
	@$(call set,META_VOL_ID,ALT Server 11.0ALPHA2 $(ARCH))
	@$(call set,META_PUBLISHER,BaseALT Ltd)
	@$(call set,META_VOL_SET,ALT)
	@$(call set,META_APP_ID,ALT Server 11.0ALPHA2 $(ARCH) $(shell date +%F))
