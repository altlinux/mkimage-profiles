ifeq (distro,$(IMAGE_CLASS))
distro/alt-platform-builder: \
	distro/.installer \
	+systemd +systemd-optimal \
	use/memtest +efi \
	use/dev/builder/base \
	use/net/dhcp use/ntp/chrony \
	use/l10n/default/ru_RU \
	use/isohybrid \
	use/install2/vnc/listen \
	use/install2/fat use/install2/repo \
	use/docs/license use/docs/indexhtml \
	use/vmguest \
	use/apt-conf/branch \
	use/volumes/regular use/luks \
	use/firmware/server use/firmware/cpu \
	use/kernel/net use/kernel/drm \
	use/net/etcnet use/net-ssh \
	use/stage2/ata use/stage2/fs use/stage2/kms use/stage2/hid use/stage2/md \
	use/stage2/mmc use/stage2/net use/stage2/net-nfs use/stage2/cifs \
	use/stage2/rtc use/stage2/sbc use/stage2/scsi use/stage2/usb \
	use/stage2/drm use/stage2/sbc use/tty
	@$(call set,BRANDING,alt-platform-builder)
#	@$(call set,INSTALLER,alt-platform-builder)
	@$(call set,INSTALLER,regular)
#	@$(call set,DOCS,alt-platform-builder)
	@$(call set,DISABLE_LANG_MENU,1)
	@$(call set,META_PUBLISHER,BaseALT Ltd)
	@$(call set,PLATFORM_RELEASE,10.0.0)
	@$(call set,META_VOL_ID,ALT Platform Builder $$(PLATFORM_RELEASE) $(ARCH))
	@$(call set,META_APP_ID,ALT Platform Builder $$(PLATFORM_RELEASE) $(ARCH) $(shell date +%F))
	@$(call add,INSTALL2_PACKAGES,fonts-ttf-google-croscore-arimo)
	@$(call add,INSTALL2_BRANDING,alterator notes)
	@$(call add,THE_BRANDING,alterator indexhtml notes)
#	@$(call add,THE_BRANDING,slideshow)
	@$(call add,INSTALL2_PACKAGES,btrfs-progs)
	@$(call add,BASE_PACKAGES,btrfs-progs timeshift)
	@$(call add,INSTALL2_PACKAGES,ntfs-3g exfatprogs)
	@$(call add,BASE_PACKAGES,ntfs-3g exfatprogs)
	@$(call add,BASE_LISTS,platform-builder/base.pkgs)
	@$(call add,BASE_LISTS,platform-builder/alterator)
	@$(call add,BASE_LISTS,platform-builder/build.pkgs)
	@$(call add,BASE_LISTS,server-base openssh)
	@$(call add,BASE_PACKAGES,eepm etersoft-build-utils)
	@$(call add,COMMON_PACKAGES,vim-console)
	@$(call add,SYSTEM_PACKAGES,mdadm-tool lvm2 multipath-tools fdisk xfsprogs btrfs-progs file)
	@$(call add,DEFAULT_SERVICES_ENABLE,getty@tty1)
	@$(call add,DEFAULT_SERVICES_ENABLE,ahttpd alteratord)
	@$(call add,DEFAULT_SERVICES_DISABLE,powertop bridge gpm)
	@$(call add,DEFAULT_SERVICES_DISABLE,consolesaver)

endif
