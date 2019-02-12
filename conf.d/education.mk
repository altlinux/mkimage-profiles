# ALT Education

ifeq (distro,$(IMAGE_CLASS))

distro/education: distro/alt-education
distro/alt-education: distro/.installer use/slinux/full \
	use/memtest \
	use/services \
	use/live/install use/live/suspend use/live/x11 use/live/repo \
	use/install2/vnc \
	use/l10n/default/ru_RU +vmguest +efi \
	use/efi/refind \
	+systemd
	@$(call set,INSTALLER,junior)
	@$(call set,BRANDING,alt-education)
	@$(call set,META_VOL_SET,ALT Education 8.2)
	@$(call add,INSTALL2_PACKAGES,xorg-drv-vmware xorg-drv-vmmouse disable-usb-autosuspend xorg-drv-libinput)
	@$(call add,INSTALL2_PACKAGES,net-tools fdisk gdisk parted partclone openssh-clients)
	@$(call add,INSTALL2_PACKAGES,xorg-conf-synaptics)
	@$(call add,INSTALL2_PACKAGES,installer-feature-samba-usershares-stage2)
	@$(call add,INSTALL2_PACKAGES,curl)
	@$(call add,INSTALL2_PACKAGES,vim-console lftp)
	@$(call add,BASE_LISTS,education/base)
	@$(call add,THE_LISTS,education/desktop)
	@$(call add,MAIN_GROUPS,education/teacher)
	@$(call add,MAIN_GROUPS,education/kde5)
	@$(call add,MAIN_GROUPS,education/server-apps-edu)
	@$(call add,THE_KMODULES,lsadrv)
	@$(call add,THE_PACKAGES,usbutils pv syslinux lftp links2 openssh-server xinput xorg-drv-libinput)
	@$(call add,THE_PACKAGES,xorg-drv-vmware xorg-drv-vmmouse disable-usb-autosuspend)
	@$(call add,THE_PACKAGES,bluez pulseaudio-bluez)
	@$(call add,THE_PACKAGES,os-prober)
	@$(call add,THE_PACKAGES,firefox-esr firefox-esr-ru)
	@$(call add,THE_PACKAGES,guest-account)
	@$(call add,THE_PACKAGES,owncloud-client)
	@$(call add,THE_PACKAGES,alterator-fbi)
	@$(call add,THE_PACKAGES,net-tools fdisk gdisk parted partclone)
	@$(call add,MAIN_PACKAGES,iperf3 owamp-server)
	@$(call add,MAIN_PACKAGES,kumir2 rujel stellarium)
	@$(call add,THE_LISTS,$(call tags,base regular))
	@$(call add,SERVICES_ENABLE,bluetoothd sshd syslogd bind crond alteratord cups ahttpd)
	@$(call add,STAGE1_MODLISTS,stage2-mmc)

endif
