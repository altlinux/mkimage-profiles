mixin/alt-server: server_groups = $(addprefix centaurus/,\
	10-alterator 20-server-apps  50-freeipa 70-dev 90-docs sambaDC buildsystem dhcp-server-a diag-tools dns-server-a ftp-server-a mail-server-a mediawiki owncloud domain-server freeipa-client)

mixin/alt-server: +installer +systemd \
	use/branding/notes use/syslinux/ui/gfxboot \
	use/plymouth/stage2 use/control use/services \
	use/l10n/default/ru_RU use/install2/stage3 \
	use/install2/vnc use/install2/xfs use/install2/fat \
	use/volumes/cliff-server \
	use/apt-conf/branch \
	use/fonts/install2 \
	use/install2/stage3 \
	use/firmware/server \
	use/net/etcnet
	@$(call set,INSTALLER,centaurus)
	@$(call set,BRANDING,alt-server)
	@$(call add,THE_BRANDING,alterator)
ifeq (,$(filter-out i586 x86_64 aarch64,$(ARCH)))
	@$(call add,THE_BRANDING,bootloader bootsplash)
	@$(call set,KFLAVOURS,std-def)
endif
	@$(call add,BASE_LISTS,centaurus/base)
	@$(call add,BASE_LISTS,centaurus/base-server)
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
	@$(call add,MAIN_GROUPS,centaurus/jitsi-meet)
endif
	@$(call add,INSTALL2_PACKAGES,fdisk)
	@$(call add,INSTALL2_PACKAGES,xorg-conf-synaptics)
	@$(call add,COMMON_PACKAGES,vim-console)
	@$(call add,DEFAULT_SERVICES_ENABLE,rpcbind sshd bind)
	@$(call set,META_VOL_ID,ALT Server 9.1 $(ARCH))
	@$(call set,META_PUBLISHER,BaseALT Ltd)
	@$(call set,META_VOL_SET,ALT)
	@$(call set,META_APP_ID,ALT Server 9.1.0 $(ARCH) $(shell date +%F))
