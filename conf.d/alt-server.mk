ifeq (distro,$(IMAGE_CLASS))

ifeq (,$(filter-out i586 x86_64 ppc64le aarch64,$(ARCH)))
distro/alt-server: server_groups_primary = $(addprefix centaurus/,\
        ipmi netinst sogo)

ifeq (,$(filter-out x86_64 ppc64le aarch64,$(ARCH)))
distro/alt-server: server_groups_virtipa = $(addprefix centaurus/,\
	v12n-server freeipa-server)
endif
endif

ifeq (,$(filter-out i586 x86_64 ppc64le aarch64 e2k%,$(ARCH)))
distro/alt-server: server_groups_desktop = $(addprefix centaurus/,\
        80-desktop emulators freenx-server mate office pidgin vlc xorg)
endif

distro/alt-server: monitoring = $(addprefix server-v/,\
	90-monitoring zabbix-agent telegraf prometheus-node_exporter \
	monit collectd nagios-nrpe)

# FIXME: generalize vm-profile
distro/alt-server:: distro/.base mixin/alt-server use/vmguest/base \
	use/bootloader/grub use/rescue/base use/stage2/kms\
	use/stage2/fs use/stage2/hid use/stage2/md \
	use/stage2/mmc use/stage2/net use/stage2/net-nfs \
	use/stage2/rtc use/stage2/sbc use/stage2/scsi use/stage2/usb \
	use/docs/license
	@$(call add,MAIN_GROUPS,$(server_groups_primary))
	@$(call add,MAIN_GROUPS,$(server_groups_virtipa))
	@$(call add,MAIN_GROUPS,$(server_groups_desktop))
	@$(call add,MAIN_LISTS,centaurus/disk-dvd)
	@$(call add,MAIN_LISTS,centaurus/disk-server-light)
ifneq (,$(filter-out e2k%,$(ARCH)))
	@$(call add,INSTALL2_PACKAGES,installer-feature-desktop-suspend-stage2)
endif
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call add,INSTALL2_PACKAGES,installer-feature-setup-plymouth)
endif
	@$(call add,INSTALL2_PACKAGES,strace)
	@$(call add,INSTALL2_PACKAGES,fdisk)
	@$(call add,INSTALL2_BRANDING,notes)
	@$(call add,BASE_KMODULES,kvm virtualbox)
	@$(call add,CLEANUP_BASE_PACKAGES,acpid-events-power)
	@$(call add,RESCUE_BOOTARGS,nomodeset vga=0)
	@$(call add,EFI_BOOTARGS,lang=ru_RU)
ifeq (,$(filter-out e2k,$(ARCH)))
	@$(call set,META_APP_ID,ALT Server for Elbrus-4.4)
endif
ifeq (,$(filter-out e2kv4,$(ARCH)))
	@$(call set,META_APP_ID,ALT Server for Elbrus-80x)
endif

ifeq (,$(filter-out x86_64 i586,$(ARCH)))
distro/alt-server:: use/memtest; @:
endif

ifeq (,$(filter-out x86_64 aarch64,$(ARCH)))
distro/alt-server:: use/efi/refind +efi; @:
endif

ifeq (,$(filter-out ppc64le aarch64 e2k%,$(ARCH)))
distro/alt-server:: use/install2/vnc/listen; @:
endif

ifeq (,$(filter-out e2k%,$(ARCH)))
distro/alt-server:: +power +net-eth; @:
endif

endif
