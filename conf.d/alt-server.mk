ifeq (distro,$(IMAGE_CLASS))

ifeq (,$(filter-out i586 x86_64 ppc64le aarch64,$(ARCH)))
distro/alt-server: server_groups_primary = $(addprefix centaurus/,\
        ipmi netinst sogo)

ifeq (,$(filter-out x86_64 ppc64le aarch64,$(ARCH)))
distro/alt-server: server_groups_virtipa = $(addprefix centaurus/,\
	freeipa-server)
endif
endif

ifeq (,$(filter-out i586 x86_64 ppc64le aarch64 e2k%,$(ARCH)))
distro/alt-server: server_groups_desktop = $(addprefix centaurus/,\
        80-desktop emulators freenx-server mate office pidgin xorg scanning samba)
endif

ifeq (,$(filter-out x86_64,$(ARCH)))
distro/alt-server: server_groups_virtualbox = $(addprefix centaurus/,\
        vbox-host vbox-guest)
endif

distro/alt-server: monitoring = $(addprefix server-v/,\
	90-monitoring zabbix-agent telegraf prometheus-node_exporter \
	monit collectd nagios-nrpe)

# FIXME: generalize vm-profile
distro/alt-server:: distro/.base mixin/alt-server use/vmguest/base \
	use/bootloader/grub use/rescue/base use/stage2/kms\
	use/stage2/ata use/stage2/fs use/stage2/hid use/stage2/md \
	use/stage2/mmc use/stage2/net use/stage2/net-nfs use/stage2/cifs \
	use/stage2/rtc use/stage2/sbc use/stage2/scsi use/stage2/usb \
	use/docs/license use/docs/manual use/docs/indexhtml
	@$(call set,DOCS,alt-server)
	@$(call add,MAIN_GROUPS,$(server_groups_primary))
	@$(call add,MAIN_GROUPS,$(server_groups_virtipa))
	@$(call add,MAIN_GROUPS,$(server_groups_desktop))
	@$(call add,MAIN_GROUPS,$(server_groups_virtualbox))
	@$(call add,MAIN_LISTS,centaurus/disk-dvd)
	@$(call add,MAIN_LISTS,centaurus/disk-server-light)
	@$(call add,THE_LISTS,monitoring/zabbix-agent)
	@$(call add,THE_LISTS,cert-ru)
ifneq (,$(filter-out e2k%,$(ARCH)))
	@$(call add,INSTALL2_PACKAGES,installer-feature-desktop-suspend-stage2)
endif
	@$(call add,STAGE2_BOOTARGS,mpath)
	@$(call add,INSTALL2_PACKAGES,installer-feature-multipath)
	@$(call add,SYSTEM_PACKAGES,multipath-tools)
	@$(call add,SERVICES_ENABLE,multipathd)
	@$(call add,INSTALL2_PACKAGES,strace)
	@$(call add,INSTALL2_PACKAGES,fdisk)
	@$(call add,INSTALL2_PACKAGES,btrfs-progs)
	@$(call add,INSTALL2_BRANDING,notes)
	@$(call add,CLEANUP_BASE_PACKAGES,acpid-events-power)
	@$(call add,RESCUE_BOOTARGS,nomodeset vga=0)
ifeq (,$(filter-out e2k,$(ARCH)))
	@$(call set,META_APP_ID,ALT Server for Elbrus-4.4)
endif
ifeq (,$(filter-out e2kv4,$(ARCH)))
	@$(call set,META_APP_ID,ALT Server for Elbrus-80x)
endif
ifeq (,$(filter-out e2kv5,$(ARCH)))
	@$(call set,META_APP_ID,ALT Server for Elbrus-90x)
endif

ifeq (,$(filter-out x86_64 i586,$(ARCH)))
distro/alt-server:: use/memtest; @:
endif

ifeq (,$(filter-out x86_64 aarch64,$(ARCH)))
distro/alt-server:: +efi; @:
endif

distro/alt-server:: use/install2/vnc/listen; @:

ifeq (,$(filter-out e2k%,$(ARCH)))
distro/alt-server:: +power +net-eth; @:
endif

endif
