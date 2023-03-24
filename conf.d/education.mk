# ALT Education

mixin/education: \
	use/kernel/desktop use/kernel/net use/kernel/laptop \
	use/firmware use/firmware/wireless use/firmware/laptop \
	+systemd +systemd-optimal \
	use/services \
	use/ntp/chrony \
	use/volumes/education \
	use/apt-conf/branch \
	+x11 use/x11/3d \
	use/x11/lightdm/gtk +pulse \
	+nm use/x11/gtk/nm \
	use/xdg-user-dirs/deep \
	use/office/LibreOffice/full \
	use/browser/chromium
	@$(call set,BRANDING,alt-education)
	@$(call add,THE_BRANDING,indexhtml)
	@$(call add,THE_BRANDING,menu xfce-settings system-settings)
	@$(call add,THE_LISTS,slinux/xfce-base)
	@$(call add,THE_LISTS,education/misc)
ifeq (,$(filter-out e2k%,$(ARCH)))
	@$(call add,THE_PACKAGES,jre)
else
	@$(call add,THE_PACKAGES,java-11-openjdk)
endif
	@$(call add,THE_PACKAGES,mousepad)
	@$(call add,THE_PACKAGES,thunderbird)
	@$(call add,THE_PACKAGES,installer-feature-lightdm-stage3)                            
	@$(call add,THE_PACKAGES,installer-feature-quota-stage2)
	@$(call add,THE_LISTS,$(call tags,base l10n))
	@$(call add,BASE_LISTS,workstation/3rdparty)
	@$(call add,THE_LISTS,$(call tags,base regular))
	@$(call add,THE_LISTS,$(call tags,base extra))

mixin/education-lite: \
	use/kernel/desktop use/kernel/net use/kernel/laptop \
	use/firmware use/firmware/wireless use/firmware/laptop \
	+systemd +systemd-optimal \
	use/services \
	use/ntp/chrony \
	use/apt-conf/branch \
	+x11 use/x11/3d \
	use/x11/lightdm/gtk +pulse \
	+nm use/x11/gtk/nm \
	use/xdg-user-dirs/deep \
	use/browser/chromium
	@$(call set,BRANDING,alt-education)
	@$(call add,THE_BRANDING,menu xfce-settings system-settings)
	@$(call add,THE_LISTS,slinux/xfce-base)
	@$(call add,THE_PACKAGES,installer-feature-lightdm-stage3)                            
	@$(call add,THE_PACKAGES,installer-feature-quota-stage2)
	@$(call add,THE_LISTS,$(call tags,base l10n))
	@$(call add,THE_LISTS,$(call tags,base regular))
	@$(call add,THE_LISTS,$(call tags,base extra))
ifeq (distro,$(IMAGE_CLASS))

mixin/education-live: \
	use/live/suspend \
	use/live/repo use/live/x11 use/live/rw \
	use/rescue/base use/memtest \
	use/cleanup/live-no-cleanupdb
	@$(call add,LIVE_PACKAGES,livecd-timezone)
	@$(call add,LIVE_PACKAGES,mc-full)
	@$(call add,LIVE_PACKAGES,remmina remmina-plugins)
	@$(call add,LIVE_PACKAGES,mousepad)
ifeq (,$(filter-out e2k%,$(ARCH)))
	@$(call add,LIVE_PACKAGES,jre)
else
	@$(call add,LIVE_PACKAGES,java-11-openjdk)
endif
	@$(call add,LIVE_PACKAGES,xorg-conf-libinput-touchpad)
	@$(call add,LIVE_PACKAGES,btrfs-progs)
	@$(call add,LIVE_PACKAGES,xfsprogs xfsinfo xfsdump)
	@$(call add,LIVE_LISTS,$(call tags,base rescue))
	@$(call add,LIVE_LISTS,$(call tags,base extra))
	@$(call add,CONTROL,tcb_chkpwd:tcb)

mixin/education-lite-live: \
	use/live/suspend \
	use/live/repo use/live/x11 use/live/rw \
	use/grub/timeout/1 use/syslinux/timeout/10 \
	use/cleanup/live-no-cleanupdb
	@$(call add,LIVE_PACKAGES,livecd-timezone)
	@$(call add,LIVE_PACKAGES,mc-full)
	@$(call add,LIVE_PACKAGES,mousepad)
	@$(call add,LIVE_PACKAGES,xorg-conf-libinput-touchpad)
	@$(call add,LIVE_LISTS,education/live-lite)
	@$(call add,CONTROL,tcb_chkpwd:tcb)
	@$(call add,DEFAULT_SERVICES_ENABLE,cups)
	@$(call set,GRUB_DEFAULT,session)
	@$(call set,SYSLINUX_DEFAULT,session)

mixin/education-base: \
	use/l10n/default/ru_RU +vmguest \
	+efi use/efi/shell \
	use/isohybrid use/luks \
	use/install2/fonts \
	use/wireless \
	+plymouth \
	use/stage2/ata use/stage2/fs use/stage2/hid use/stage2/md \
	use/stage2/mmc use/stage2/net use/stage2/net-nfs use/stage2/cifs \
	use/stage2/rtc use/stage2/sbc use/stage2/scsi use/stage2/usb
	@$(call set,INSTALLER,education)
	@$(call set,META_VOL_ID,ALT Education 10.1 $(ARCH))
	@$(call set,META_PUBLISHER,BaseALT Ltd)
	@$(call set,META_APP_ID,$(DISTRO_VERSION) $(ARCH))
	@$(call set,META_VOL_SET,ALT)
	@$(call add,THE_PACKAGES,bluez pulseaudio-bluez)
	@$(call add,THE_PACKAGES,alterator-fbi)
	@$(call add,THE_PACKAGES,alt-rootfs-installer)
	@$(call add,THE_PACKAGES,btrfs-progs)
	@$(call add,STAGE2_PACKAGES,xorg-conf-libinput-touchpad)
	@$(call add,STAGE2_PACKAGES,chrony)

mixin/education-lite-base: \
	use/l10n/default/ru_RU +vmguest \
	+efi use/efi/shell \
	use/isohybrid use/luks \
	use/install2/fonts \
	use/wireless \
	+plymouth \
	use/stage2/ata use/stage2/fs use/stage2/hid use/stage2/md \
	use/stage2/mmc use/stage2/net use/stage2/net-nfs use/stage2/cifs \
	use/stage2/rtc use/stage2/sbc use/stage2/scsi use/stage2/usb
	@$(call set,INSTALLER,education)
	@$(call set,META_VOL_ID,ALT Education 10.1 $(ARCH))
	@$(call set,META_PUBLISHER,BaseALT Ltd)
	@$(call set,META_APP_ID,$(DISTRO_VERSION) $(ARCH))
	@$(call set,META_VOL_SET,ALT)
	@$(call add,STAGE2_PACKAGES,xorg-conf-libinput-touchpad)
	@$(call add,STAGE2_PACKAGES,chrony)

mixin/education-installer: \
	+installer \
	use/install2/repo \
	use/rescue/base use/memtest \
	use/branding/complete \
	use/install2/vnc use/install2/full \
	use/install2/fat \
	mixin/education-base \
	use/docs/manual use/docs/indexhtml
	@$(call add,INSTALL2_PACKAGES,disable-usb-autosuspend)
	@$(call add,INSTALL2_PACKAGES,btrfs-progs)
	@$(call add,MAIN_GROUPS,education/00_base)
	@$(call add,MAIN_GROUPS,education/01_preschool)
	@$(call add,MAIN_GROUPS,education/02_gradeschool)
	@$(call add,MAIN_GROUPS,education/03_highschool)
	@$(call add,MAIN_GROUPS,education/04_secondary_vocational)
	@$(call add,MAIN_GROUPS,education/05_university)
	@$(call add,MAIN_GROUPS,education/07_teacher)
	@$(call add,MAIN_GROUPS,education/08_server-apps-edu)
	@$(call add,BASE_PACKAGES,os-prober)
	@$(call add,BASE_PACKAGES,guest-account)
	@$(call add,MAIN_PACKAGES,iperf3)
	@$(call add,MAIN_PACKAGES,stellarium)
	@$(call add,MAIN_PACKAGES,libreoffice-block-macros)
	@$(call add,MAIN_PACKAGES,lmms)
	@$(call add,MAIN_PACKAGES,xorg-conf-libinput-touchpad)
	@$(call add,MAIN_PACKAGES,settings-alsa-sof-force)
	@$(call set,DOCS,alt-education)

#FIXME#	mixin/education-live \
	#
distro/alt-education-live: distro/.base mixin/education-live \
	mixin/education-base mixin/education use/branding/full; @:

distro/alt-education-lite-live: distro/.base mixin/education-lite-live \
	mixin/education-lite-base mixin/education-lite use/branding/full; @:

distro/education: distro/alt-education; @:
distro/alt-education: distro/.installer \
	mixin/education \
	mixin/education-installer \
	use/e2k/multiseat/full use/power/acpi \
	use/control
	@$(call set,INSTALLER,education)
ifeq (,$(filter-out e2k%,$(ARCH)))
	@$(call add,MAIN_GROUPS,education/06_kdesc)
	@$(call add,MAIN_PACKAGES,xorg-conf-noblank)
	@$(call add,THE_PACKAGES,firefox-esr-ru flashrom)
	@$(call add,THE_PACKAGES,xscreensaver-hacks-rss_glx)
	@$(call add,CLEANUP_PACKAGES,plymouth plymouth-scripts)
	@$(call add,CONTROL,pam_mktemp:disabled)	### private /tmp dirs
else
	@$(call add,MAIN_GROUPS,education/06_kde5)
	@$(call add,MAIN_GROUPS,education/09_video-conferencing)
endif	# e2k%
ifeq (,$(filter-out i586 x86_64 aarch64,$(ARCH)))
	@$(call set,KFLAVOURS,std-def un-def)
	@$(call add,MAIN_PACKAGES,kernel-headers-std-def)
	@$(call add,MAIN_PACKAGES,kernel-headers-modules-std-def)
	@$(call add,MAIN_PACKAGES,kernel-headers-std-def)
	@$(call add,MAIN_PACKAGES,kernel-headers-modules-std-def)
	@$(call add,THE_KMODULES,virtualbox)
	@$(call add,THE_KMODULES,lsadrv bbswitch)
	@$(call add,THE_KMODULES,staging)
	@$(call add,MAIN_KMODULES,bbswitch)
	@$(call add,THE_PACKAGES,mc-full)
	@$(call add,THE_PACKAGES,remmina remmina-plugins)
endif
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call add,THE_PACKAGES,syslinux)
	@$(call add,MAIN_PACKAGES,owamp-server)
endif
	@$(call add,CONTROL,sudo:public)
	@$(call add,CONTROL,fusermount:wheelonly)

endif # distro

ifeq (vm,$(IMAGE_CLASS))

vm/.alt-education: vm/systemd use/repo use/oem/distro mixin/education
	@$(call add,DEFAULT_SERVICES_DISABLE,multipathd)
	@$(call add,THE_PACKAGES,task-edu-lite)
	@$(call add,PINNED_PACKAGES,task-edu-lite:Extra)

vm/alt-education:: vm/.alt-education +vmguest; @:

ifeq (,$(filter-out aarch64 riscv64,$(ARCH)))
vm/alt-education:: use/uboot
	@$(call add,BASE_LISTS,uboot)
endif

ifeq (,$(filter-out aarch64,$(ARCH)))
vm/alt-education:: use/no-sleep use/arm-rpi4; @:
endif

ifeq (,$(filter-out aarch64,$(ARCH)))
vm/alt-education-rpi: vm/.alt-education use/arm-rpi4/full; @:
endif

endif
