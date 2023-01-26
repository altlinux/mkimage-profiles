mixin/alt-server: server_groups = $(addprefix centaurus/,\
	10-alterator 20-server-apps 50-freeipa 70-dev 901-net-if-mgt \
	sambaDC buildsystem dhcp-server-a diag-tools dns-server-a ftp-server-a \
	mail-server-a owncloud freeipa-client nm-daemon \
	systemd-networkd openuds openuds-tunnel admc)

mixin/alt-server: server_main_kmodules = bcmwl ch34x dm-secdel drbd9 drm-ancient \
	drm-nouveau drm e1000e hifc hinic i40e ide ipset ipt_netflow ipt-ratelimit \
	ipt-so ixgbe kvdo LiME linux-gpib lsadrv ndpi nvidia nxp-pn71xx-getmobit \
	promethean r8125 r8168 rtl8168 rtl8188fu rtl8192eu rtl8192fu rtl8723bu \
	rtl8812au rtl8821ce rtl8821cu rtl88x2bu rtw89 staging tripso usb-vhci \
	v4l2loopback vboxsf vhba virtualbox-addition-guest virtualbox-addition \
	virtualbox-addition-video virtualbox xtables-addons

mixin/alt-server: +installer +systemd \
	use/branding/notes \
	use/control use/services \
	use/install2/stage3 \
	use/install2/vnc use/install2/xfs use/install2/fat \
	use/volumes/alt-server \
	use/apt-conf/branch \
	use/fonts/install2 \
	use/install2/stage3 \
	use/firmware/full \
	use/net/etcnet \
	use/tty
	@$(call set,INSTALLER,centaurus)
	@$(call set,BRANDING,alt-server)
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call set,BOOTLOADER,grubpcboot)
endif
	@$(call add,THE_BRANDING,alterator)
ifeq (,$(filter-out i586 x86_64 aarch64,$(ARCH)))
	@$(call set,KFLAVOURS,std-def)
	@$(call add,INSTALL2_PACKAGES,ntfs-3g)
	@$(call add,BASE_KMODULES,drm)
	@$(call add,MAIN_GROUPS,centaurus/proxmox-backup-server)
	@$(call add,MAIN_GROUPS,centaurus/token)
	@$(call add,MAIN_PACKAGES,mate-reduced-resource)
endif
	@$(call add,MAIN_KMODULES,$(server_main_kmodules))
	@$(call add,BASE_LISTS,centaurus/base)
	@$(call add,BASE_LISTS,centaurus/base-server)
	@$(call add,BASE_LISTS,centaurus/lsb-core)
	@$(call add,LIVE_LISTS,centaurus/live)
	@$(call add,LIVE_LISTS,centaurus/remmina)
	@$(call add,LIVE_LISTS,centaurus/cups)
	@$(call add,LIVE_LISTS,centaurus/nm)
	@$(call add,LIVE_LISTS,centaurus/domain-client)
	@$(call add,MAIN_GROUPS,$(server_groups))
	@$(call add,MAIN_LISTS,centaurus/cppcheck)
	@$(call add,MAIN_LISTS,centaurus/disk)
	@$(call add,THE_PROFILES,centaurus-10-server)
	@$(call add,THE_PROFILES,centaurus-20-serverDC)
ifeq (,$(filter-out i586 x86_64 aarch64 e2k%,$(ARCH)))
	@$(call add,THE_PROFILES,centaurus-30-desktop)
endif
	@$(call add,THE_PROFILES,minimal)
	@$(call add,STAGE1_MODLISTS,stage2-mmc)
	@$(call add,INSTALL2_PACKAGES,installer-feature-multipath)
	@$(call add,INSTALL2_PACKAGES,installer-feature-desktop-other-fs-stage2)
	@$(call add,INSTALL2_PACKAGES,installer-feature-alphabet-profiles)
	@$(call add,INSTALL2_PACKAGES,installer-feature-load-tun)
	@$(call add,INSTALL2_PACKAGES,installer-feature-network-shares-stage3)
	@$(call add,INSTALL2_PACKAGES,installer-feature-auto-domain)
ifneq (,$(filter-out e2k%,$(ARCH)))
	@$(call add,INSTALL2_PACKAGES,installer-feature-quota-stage2)
endif
ifeq (,$(filter-out x86_64,$(ARCH)))
	@$(call add,MAIN_GROUPS,centaurus/jitsi-meet)
endif
	@$(call add,INSTALL2_PACKAGES,fdisk)
	@$(call add,INSTALL2_PACKAGES,xorg-conf-synaptics)
	@$(call add,COMMON_PACKAGES,vim-console)
	@$(call add,DEFAULT_SERVICES_ENABLE,rpcbind sshd bind)
	@$(call set,META_VOL_ID,ALT Server 10.1 $(ARCH))
	@$(call set,META_PUBLISHER,BaseALT Ltd)
	@$(call set,META_VOL_SET,ALT)
	@$(call set,META_APP_ID,ALT Server 10.1 $(ARCH) $(shell date +%F))
