ifeq (distro,$(IMAGE_CLASS))

ifeq (,$(filter-out i586 x86_64 ppc64le aarch64,$(ARCH)))
distro/alt-server: server_groups_x86 = $(addprefix centaurus/,\
        emulators freenx-server \
	ipmi netinst sogo 80-desktop mate office pidgin vlc xorg)

ifeq (,$(filter-out x86_64 ppc64le aarch64,$(ARCH)))
distro/alt-server: server_groups_x86_64 = $(addprefix centaurus/,\
       freeipa-server v12n-server)
distro/alt-server: use/efi/refind use/memtest +efi
endif
endif

ifeq (,$(filter-out ppc64le aarch64,$(ARCH)))
distro/.alt-server-vnc: use/install2/vnc/listen; @:
else
distro/.alt-server-vnc: ; @:
endif

# FIXME: generalize vm-profile
distro/alt-server: distro/.base distro/.alt-server-vnc \
	mixin/alt-server use/vmguest/base use/vmguest/kvm/x11\
	use/bootloader/grub use/rescue/base use/stage2/kms\
	use/stage2/fs use/stage2/hid use/stage2/md \
	use/stage2/mmc use/stage2/net use/stage2/net-nfs \
	use/stage2/rtc use/stage2/sbc use/stage2/scsi use/stage2/usb \
	use/docs/license
	@$(call add,MAIN_GROUPS,$(server_groups_x86))
	@$(call add,MAIN_GROUPS,$(server_groups_x86_64))
	@$(call add,MAIN_LISTS,centaurus/disk-dvd)
	@$(call add,MAIN_LISTS,centaurus/disk-server-light)
	@$(call add,INSTALL2_PACKAGES,installer-feature-desktop-suspend-stage2)
	@$(call add,INSTALL2_PACKAGES,strace)
	@$(call add,INSTALL2_PACKAGES,fdisk)
	@$(call add,BASE_KMODULES,kvm virtualbox)
	@$(call add,CLEANUP_BASE_PACKAGES,acpid-events-power)
	@$(call add,RESCUE_BOOTARGS,nomodeset vga=0)
	@$(call add,EFI_BOOTARGS,lang=ru_RU)
distro/alt-server: monitoring = $(addprefix server-v/, 90-monitoring \
	zabbix-agent telegraf prometheus-node_exporter monit collectd nagios-nrpe)

ifeq (,$(filter-out e2k%,$(ARCH)))

distro/alt-server: distro/.e2k-installer mixin/alt-server
ifeq (,$(filter-out e2k,$(ARCH)))
	@$(call set,META_APP_ID,ALT Server for Elbrus-4.4)
endif
ifeq (,$(filter-out e2kv4,$(ARCH)))
	@$(call set,META_APP_ID,ALT Server for Elbrus-80x)
endif

endif

endif
