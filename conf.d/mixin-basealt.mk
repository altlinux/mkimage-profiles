# shared across all supported arches, can be complemented per arch

mixin/alt-workstation-install: workstation_groups = $(addprefix workstation/,\
	10-office 20-networking 30-multimedia 40-virtualization \
	raccess agents emulators ganttproject gnome-peer-to-peer graphics-editing \
	libreoffice mate-usershare pidgin scanning scribus \
	sound-editing thunderbird freeipa-client gpolicy)

mixin/alt-workstation: +systemd +systemd-optimal +pulse +nm \
	use/kernel/net use/l10n/default/ru_RU \
	use/x11/xorg use/x11-autostart use/x11/gtk/nm \
	use/ntp/chrony \
	use/apt-conf/branch use/volumes/alt-workstation \
	use/fonts/install2 \
	use/fonts/otf/adobe use/fonts/otf/mozilla \
	use/fonts/ttf/google use/fonts/ttf/google/extra \
	use/fonts/ttf/redhat use/fonts/ttf/ubuntu \
	use/branding use/control use/services \
	use/sound use/xdg-user-dirs \
	use/docs/manual use/docs/indexhtml \
	use/browser/firefox use/browser/firefox/esr \
	use/cleanup/live-no-cleanupdb
ifeq (,$(filter-out x86_64,$(ARCH)))
	@$(call set,KFLAVOURS,un-def std-def)
	@$(call add,MAIN_PACKAGES,kernel-headers-modules-un-def)
	@$(call add,MAIN_PACKAGES,kernel-headers-un-def)
else
ifeq (,$(filter-out aarch64,$(ARCH)))
	@$(call set,KFLAVOURS,rpi-un std-def)
	@$(call add,MAIN_PACKAGES,kernel-headers-modules-rpi-un)
	@$(call add,MAIN_PACKAGES,kernel-headers-rpi-un)
else
	@$(call set,KFLAVOURS,std-def)
endif
endif
	@$(call add,MAIN_PACKAGES,kernel-headers-modules-std-def)
	@$(call add,MAIN_PACKAGES,kernel-headers-std-def)
	@$(call set,BRANDING,alt-workstation)
	@$(call add,THE_BRANDING,mate-settings)
	@$(call add,COMMON_PACKAGES,vim-console)
	@$(call add,BASE_LISTS,workstation/base.pkgs)
	@$(call add,THE_LISTS,workstation/the.pkgs)
	@$(call add,THE_LISTS,$(call tags,archive extra))
	@$(call add,THE_LISTS,$(call tags,mobile mate))
	@$(call add,BASE_LISTS,$(call tags,desktop cups))
	@$(call add,LIVE_LISTS,workstation/live.pkgs)
	@$(call add,LIVE_LISTS,workstation/scanning)
ifneq (,$(filter-out armh,$(ARCH)))
	@$(call add,LIVE_LISTS,workstation/libreoffice)
endif
	@$(call add,THE_LISTS,workstation/mate)
	@$(call add,THE_LISTS,$(call tags,regular desktop))
	@$(call add,THE_LISTS,$(call tags,base regular))
	@$(call add,THE_LISTS,$(call tags,base l10n))
	@$(call add,THE_LISTS,$(call tags,base desktop))
	@$(call add,THE_LISTS,$(call tags,xorg vaapi))
	@$(call add,THE_KMODULES,staging)
	@$(call add,CONTROL,xdg-user-dirs:enabled)
	@$(call add,SERVICES_DISABLE,sshd)
	@$(call add,SERVICES_DISABLE,auditd)
	@$(call add,SERVICES_ENABLE,cups cups-browsed smb nmb httpd2 bluetoothd libvirtd)
	@$(call add,SERVICES_ENABLE,crond)
	@$(call add,SERVICES_ENABLE,fstrim.timer)
	@$(call add,SERVICES_DISABLE,powertop bridge gpm)
	@$(call add,SYSTEMD_SERVICES_DISABLE,systemd-userdbd.service)
	@$(call add,SYSTEMD_SERVICES_DISABLE,systemd-userdbd.socket)
	@$(call set,META_PUBLISHER,BaseALT Ltd)
	@$(call set,META_VOL_SET,ALT)
	@$(call set,META_VOL_ID,ALT Workstation $(DISTRO_VERSION) $(ARCH))
	@$(call set,META_APP_ID,ALT Workstation $(DISTRO_VERSION) $(ARCH) $(shell date +%F))
	@$(call set,DOCS,alt-workstation)
	@$(call add,PINNED_PACKAGES,postfix)

mixin/alt-workstation-install: +installer \
	use/install2/fat use/install2/vnc \
	use/stage2/ata use/stage2/fs use/stage2/hid use/stage2/md \
	use/stage2/mmc use/stage2/net use/stage2/net-nfs use/stage2/cifs \
	use/stage2/rtc use/stage2/sbc use/stage2/scsi use/stage2/usb
	@$(call set,INSTALLER,alt-workstation)
	@$(call add,INSTALL2_PACKAGES,installer-feature-slideshow)
	@$(call add,INSTALL2_PACKAGES,alterator-notes)
	@$(call add,INSTALL2_PACKAGES,fdisk)
	@$(call add,INSTALL2_PACKAGES,btrfs-progs)
	@$(call add,INSTALL2_PACKAGES,open-iscsi)
	@$(call add,INSTALL2_PACKAGES,xorg-conf-libinput-touchpad)
	@$(call add,THE_PACKAGES,installer-feature-repo-add)
ifneq (,$(filter-out e2k%,$(ARCH)))
	@$(call add,INSTALL2_PACKAGES,installer-feature-quota-stage2)
	@$(call add,LIVE_PACKAGES,installer-feature-quota-stage2)
	@$(call add,MAIN_LISTS,workstation/extras)
endif
	@$(call add,LIVE_PACKAGES,livecd-installer-features)
	@$(call add,LIVE_PACKAGES,installer-feature-lightdm-stage3)
	@$(call add,LIVE_PACKAGES,alterator-gpupdate)
	@$(call add,MAIN_PACKAGES,solaar)
	@$(call add,STAGE2_PACKAGES,chrony)
	@$(call add,MAIN_GROUPS,$(workstation_groups))
