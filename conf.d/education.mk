# ALT Education

ifeq (distro,$(IMAGE_CLASS))

distro/education: distro/.installer use/slinux/full \
	use/memtest \
	use/services \
	use/live/install use/live/suspend use/live/x11 use/live/repo \
	use/l10n/default/ru_RU +vmguest +efi \
	use/efi/refind \
	+systemd
	@$(call set,INSTALLER,junior)
	@$(call set,BRANDING,alt-education)
	@$(call set,META_VOL_SET,ALT Education 8.0)
	@$(call add,INSTALL2_PACKAGES,xorg-drv-vmware xorg-drv-vmmouse disable-usb-autosuspend xorg-drv-libinput)
	@$(call add,BASE_LISTS,education/base)
	@$(call add,MAIN_GROUPS,education/teacher)
	@$(call add,MAIN_GROUPS,education/kde5)
	@$(call add,MAIN_GROUPS,education/server-apps-edu)
	@$(call add,THE_PACKAGES,usbutils pv syslinux lftp links2 openssh-server xinput xorg-drv-libinput vim-console)
	@$(call add,THE_KMODULES,lsadrv)
	@$(call add,THE_PACKAGES,xorg-drv-vmware xorg-drv-vmmouse disable-usb-autosuspend)
	@$(call add,THE_PACKAGES,bluez pulseaudio-bluez)
	@$(call add,THE_PACKAGES,os-prober)
	@$(call add,THE_PACKAGES,firefox-esr firefox-esr-ru)
	@$(call add,THE_PACKAGES,guest-account)
	@$(call add,THE_PACKAGES,owncloud-client)
	@$(call add,MAIN_PACKAGES,iperf3 owamp-server)
	@$(call add,MAIN_PACKAGES,kumir2 rujel)
	@$(call add,INSTALL2_PACKAGES,installer-feature-samba-usershares-stage2)
	@$(call add,THE_LISTS,education/desktop)
	@$(call add,SERVICES_ENABLE,bluetoothd sshd syslogd)

endif
