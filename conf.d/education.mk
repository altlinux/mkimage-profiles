# ALT Education

mixin/education: \
	use/kernel/desktop use/kernel/net use/kernel/laptop \
	use/firmware use/firmware/wireless use/firmware/laptop \
	+systemd +systemd-optimal \
	use/services \
	use/ntp/chrony \
	use/volumes/education \
	+x11 use/x11/3d \
	use/x11/lightdm/gtk +pulse \
	+nm use/x11/gtk/nm use/net-eth/dhcp \
	use/xdg-user-dirs/deep \
	use/office/LibreOffice/still \
	use/office/LibreOffice/gtk3 \
	use/office/LibreOffice/extensions \
	use/office/LibreOffice/integrated
	@$(call set,BRANDING,alt-education)
	@$(call add,THE_BRANDING,indexhtml)
	@$(call add,THE_BRANDING,menu xfce-settings system-settings)
	@$(call add,THE_LISTS,slinux/xfce-base)
	@$(call add,THE_LISTS,education/installer-features)
	@$(call add,THE_LISTS,education/misc)
	@$(call add,THE_LISTS,$(call tags,base l10n))
	@$(call add,BASE_LISTS,workstation/3rdparty)
	@$(call add,THE_PACKAGES,usbutils pv lftp links2 openssh-server)
	@$(call add,THE_PACKAGES,xinput xorg-drv-libinput)
	@$(call add,THE_PACKAGES,net-tools fdisk gdisk parted partclone)
	@$(call add,THE_PACKAGES,disable-usb-autosuspend)
	@$(call add,THE_LISTS,$(call tags,base regular))

ifeq (distro,$(IMAGE_CLASS))

mixin/education-live: \
	use/live/install use/live/suspend \
	use/live/repo use/live/x11 use/live/rw \
	use/cleanup/live-no-cleanupdb
	@$(call add,LIVE_PACKAGES,livecd-timezone)
	@$(call add,LIVE_PACKAGES,chromium)
	@$(call add,LIVE_PACKAGES,mc-full)
	@$(call add,LIVE_PACKAGES,remmina remmina-plugins)
	@$(call add,LIVE_LISTS,$(call tags,base rescue))

mixin/education-installer: \
	+installer \
	use/memtest \
	use/branding/complete \
	use/install2/vnc use/install2/full \
	use/l10n/default/ru_RU +vmguest \
	+efi use/efi/shell \
	use/isohybrid use/luks \
	use/install2/fonts \
	use/wireless \
	+plymouth \
	use/stage2/fs use/stage2/hid use/stage2/md \
	use/stage2/mmc use/stage2/net use/stage2/net-nfs \
	use/stage2/rtc use/stage2/sbc use/stage2/scsi use/stage2/usb
	@$(call set,INSTALLER,education)
	@$(call set,META_VOL_ID,ALT Education 9.1 $(ARCH))
	@$(call set,META_PUBLISHER,BaseALT Ltd)
	@$(call set,META_APP_ID,$(DISTRO_VERSION) $(ARCH))
	@$(call set,META_VOL_SET,ALT)
	@$(call add,INSTALL2_PACKAGES,disable-usb-autosuspend)
	@$(call add,INSTALL2_PACKAGES,installer-feature-samba-usershares-stage2)
	@$(call add,MAIN_LISTS,slinux/not-install-full)
	@$(call add,MAIN_GROUPS,education/00_base)
	@$(call add,MAIN_GROUPS,education/01_preschool)
	@$(call add,MAIN_GROUPS,education/02_gradeschool)
	@$(call add,MAIN_GROUPS,education/03_highschool)
	@$(call add,MAIN_GROUPS,education/04_secondary_vocational)
	@$(call add,MAIN_GROUPS,education/05_university)
	@$(call add,MAIN_GROUPS,education/07_teacher)
	@$(call add,MAIN_GROUPS,education/08_server-apps-edu)
	@$(call add,THE_PACKAGES,bluez pulseaudio-bluez)
	@$(call add,THE_PACKAGES,alterator-fbi)
	@$(call add,THE_PACKAGES,alt-rootfs-installer)
	@$(call add,BASE_PACKAGES,os-prober)
	@$(call add,BASE_PACKAGES,guest-account)
	@$(call add,MAIN_PACKAGES,iperf3)
	@$(call add,MAIN_PACKAGES,stellarium)
	@$(call add,MAIN_PACKAGES,libreoffice-block-macros)
	@$(call add,MAIN_PACKAGES,lmms)
	@$(call add,STAGE2_PACKAGES,xorg-conf-libinput-touchpad)
	@$(call add,STAGE2_PACKAGES,chrony)
	@$(call add,STAGE1_MODLISTS,stage2-mmc)

#FIXME#	mixin/education-live \
	#
distro/education: distro/alt-education; @:
distro/alt-education: distro/.installer \
	mixin/education \
	mixin/education-live \
	mixin/education-installer \
	use/e2k/multiseat/801/full +power
	@$(call set,INSTALLER,education)
ifeq (,$(filter-out e2k%,$(ARCH)))
	@$(call add,MAIN_GROUPS,education/06_kdesc)
	@$(call add,MAIN_PACKAGES,xorg-conf-noblank)
	@$(call add,THE_PACKAGES,firefox-esr-ru flashrom)
	@$(call add,THE_PACKAGES,xscreensaver-hacks-rss_glx)
	@$(call add,DEFAULT_SERVICES_ENABLE,acpid dnsmasq)
	@$(call add,DEFAULT_SERVICES_DISABLE,upower clamd clamsmtpd)
	@$(call add,CLEANUP_PACKAGES,plymouth plymouth-scripts)
	@$(call add,CONTROL,pam_mktemp:disabled)	### private /tmp dirs
	@$(call add,INSTALL2_PACKAGES,ImageMagick-tools)	### DROPME: for import on /pkg ###
else
	@$(call add,MAIN_GROUPS,education/06_kde5)
	@$(call add,MAIN_GROUPS,education/09_video-conferencing)
endif	# e2k%
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call set,KFLAVOURS,un-def)
	@$(call add,MAIN_PACKAGES,kernel-headers-un-def)
	@$(call add,MAIN_PACKAGES,kernel-headers-modules-un-def)
	@$(call add,MAIN_PACKAGES,kernel-headers-un-def)
	@$(call add,MAIN_PACKAGES,kernel-headers-modules-un-def)
	@$(call add,THE_KMODULES,virtualbox)
	@$(call add,THE_KMODULES,nvidia)
	@$(call add,THE_KMODULES,lsadrv bbswitch)
	@$(call add,THE_KMODULES,staging)
	@$(call add,MAIN_KMODULES,bbswitch)
	@$(call add,BASE_PACKAGES,nextcloud-client)
	@$(call add,THE_PACKAGES,syslinux)
	@$(call add,MAIN_PACKAGES,owamp-server)

endif

endif # distro

ifeq (vm,$(IMAGE_CLASS))

vm/.alt-education: vm/systemd use/repo use/oem/distro mixin/education
	@$(call add,DEFAULT_SERVICES_DISABLE,multipathd)
	@$(call add,THE_PACKAGES,installer-feature-lightdm-stage3)
	@$(call add,THE_PACKAGES,installer-feature-quota-stage2)

vm/alt-education:: vm/.alt-education

ifeq (,$(filter-out aarch64 armh riscv64,$(ARCH)))
vm/alt-education:: use/uboot
	@$(call add,BASE_LISTS,uboot)
endif

ifeq (,$(filter-out aarch64 armh,$(ARCH)))
vm/alt-education-rpi: vm/.alt-education use/arm-rpi4/full; @:
endif

ifeq (,$(filter-out aarch64,$(ARCH)))
vm/alt-education-tegra: vm/.alt-education use/aarch64-tegra; @:
endif

ifeq (,$(filter-out armh,$(ARCH)))
vm/alt-education-mcom02: vm/.alt-education use/armh-mcom02/x11; @:
endif

ifeq (,$(filter-out mipsel,$(ARCH)))
vm/alt-education-tavolga: vm/.alt-education use/mipsel-mitx/x11; @:
vm/alt-education-bfk3: vm/.alt-education use/mipsel-bfk3/x11; @:
endif

endif
