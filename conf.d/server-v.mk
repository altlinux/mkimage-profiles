# server distributions
ifeq (distro,$(IMAGE_CLASS))

distro/server-v: cockpit = $(addprefix server-v/cockpit/,\
	docker kvm web)

distro/server-v: ceph = $(addprefix server-v/ceph/,\
	client mgr mon osd radosgw)

distro/server-v: glusterfs = $(addprefix server-v/glusterfs/,\
	client server)

distro/server-v: iscsi = $(addprefix server-v/iscsi/,\
	initiator  scsitarget  targetcli)

distro/server-v: moosefs = $(addprefix server-v/moosefs/,\
	cgiserv chunkserver client master metalogger)

distro/server-v: lizardfs = $(addprefix server-v/lizardfs/,\
	cgiserv chunkserver client master metalogger)

distro/server-v: linstor = $(addprefix server-v/linstor/,\
	client controller satellite opennebula-addon)

distro/server-v: nfs = $(addprefix server-v/,\
	nfs nfs-ganesha)

distro/server-v: opennebula = $(addprefix server-v/opennebula/,\
	flow gate gui node-kvm node-lxd server)

distro/server-v: openstack = $(addprefix server-v/openstack/,\
	block compute controller network)
# storage

distro/server-v: container = $(addprefix server-v/,\
	docker kubernetes-master kubernetes-node podman lxd)

distro/server-v: network = $(addprefix server-v/,\
	apache2 nginx bird dhcp dns haproxy keepalived openvswitch freeipa-client)

distro/server-v: monitoring = $(addprefix server-v/,\
	zabbix-agent telegraf prometheus-node_exporter monit collectd nagios-nrpe)
# zabbix prometheus influxdb grafana

distro/server-v: backup = $(addprefix server-v/,\
	bacula urbackup-client)

distro/server-v: logging = $(addprefix server-v/,\
	rsyslog-classic systemd-journal-remote)

distro/server-v: profiles = $(addprefix server-v/,\
	111-opennebula-node 112-opennebula-server 140-basic 201-docker)
#121-openstack-node 122-openstack-controller 

ifeq (,$(filter-out x86_64 aarch64,$(ARCH)))
distro/server-v: profiles_arch = $(addprefix server-v/,\
	130-pve)
# 211-openvz
endif

distro/.server-v-base: distro/.base distro/.installer \
	use/efi/shell use/efi/grub +efi \
	use/memtest use/rescue/base \
	+systemd-optimal \
	use/services use/control \
	use/l10n/default/ru_RU \
	use/isohybrid \
	use/install2/vnc/full \
	use/install2/xfs use/install2/fat use/install2/stage3 \
	use/kernel/server use/kernel/drm \
	use/firmware use/firmware/cpu \
	use/net/etcnet use/net-ssh \
	use/stage2/fs use/stage2/hid use/stage2/md \
	use/stage2/mmc use/stage2/net use/stage2/net-nfs \
	use/stage2/rtc use/stage2/scsi use/stage2/usb \
	use/stage2/kms \
	use/server/virt use/docs/license
	@$(call add,BASE_LISTS,server-base openssh)
	@$(call add,EFI_BOOTARGS,lang=ru_RU)
	@$(call set,BRANDING,alt-server-v)
	@$(call set,INSTALLER,alt-server-v)
	@$(call add,INSTALL2_PACKAGES,alterator-notes)
	@$(call add,INSTALL2_PACKAGES,installer-feature-multipath)
	@$(call add,INSTALL2_PACKAGES,installer-feature-server-raid-fixup-stage2)
	@$(call add,INSTALL2_PACKAGES,installer-feature-quota-stage2)
	@$(call add,INSTALL2_PACKAGES,fonts-ttf-google-croscore-arimo)
	@$(call add,INSTALL2_PACKAGES,ntfs-3g)
	@$(call add,INSTALL2_BRANDING,bootloader bootsplash notes slideshow)
	@$(call add,THE_BRANDING,alterator graphics)
	@$(call add,THE_BRANDING,indexhtml slideshow)
	@$(call add,THE_PACKAGES,alterator-fbi alterator-notes)
	@$(call add,THE_LISTS,$(call tags,basesystem alterator))
	@$(call add,THE_LISTS,$(call tags,server alterator))
	@$(call add,THE_LISTS,$(call tags,server network))
	@$(call add,COMMON_PACKAGES,vim-console)
	@$(call add,SYSTEM_PACKAGES,mdadm-tool lvm2 multipath-tools fdisk xfsprogs btrfs-progs file)

distro/server-v: distro/.server-v-base +installer \
	use/ntp/chrony \
	use/install2/net use/install2/autoinstall \
	use/apt-conf/branch use/install2/repo
	@$(call add,RESCUE_BOOTARGS,nomodeset vga=0)
	@$(call set,IMAGE_FLAVOUR,$(subst alt-9-,,$(IMAGE_NAME)))
	@$(call set,META_VOL_ID,ALT Server-V 9.1.0 $(ARCH))
	@$(call set,META_PUBLISHER,BaseALT Ltd)
	@$(call set,META_VOL_SET,ALT)
	@$(call set,META_APP_ID,ALT Server-V 9.1.0 $(ARCH) $(shell date +%F))
	@$(call set,DOCS,alt-server-v)
	@$(call add,BASE_LISTS,virt/base.pkgs)
	@$(call add,MAIN_LISTS,virt/extra.pkgs)
	@$(call add,MAIN_GROUPS,server-v/110-opennebula $(opennebula))
ifeq (,$(filter-out x86_64 aarch64,$(ARCH)))
	@$(call add,MAIN_GROUPS,server-v/130-pve server-v/pve server-v/linstor/pve-storage)
endif
	@$(call add,MAIN_GROUPS,server-v/140-basic server-v/kvm)
	@$(call add,MAIN_GROUPS,server-v/200-container $(container))
	@$(call add,MAIN_GROUPS,server-v/300-cluster server-v/corosync_pacemaker)
	@$(call add,MAIN_GROUPS,server-v/400-storage)
	@$(call add,MAIN_GROUPS,server-v/410-ceph $(ceph))
	@$(call add,MAIN_GROUPS,server-v/420-glusterfs $(glusterfs))
	@$(call add,MAIN_GROUPS,server-v/450-nfs $(nfs))
	@$(call add,MAIN_GROUPS,server-v/460-iscsi $(iscsi))
	@$(call add,MAIN_GROUPS,server-v/470-linstor $(linstor))
	@$(call add,MAIN_GROUPS,server-v/500-network $(network))
	@$(call add,MAIN_GROUPS,server-v/600-monitoring $(monitoring))
	@$(call add,MAIN_GROUPS,server-v/700-backup $(backup))
	@$(call add,MAIN_GROUPS,server-v/800-logging $(logging))
	@$(call add,THE_PROFILES,$(profiles) $(profiles_arch) minimal)
	@$(call add,DEFAULT_SERVICES_ENABLE,getty@tty1 getty@ttyS0)
	@$(call add,DEFAULT_SERVICES_ENABLE,fstrim.timer)
	@$(call add,DEFAULT_SERVICES_ENABLE,libvirtd)
	@$(call add,DEFAULT_SERVICES_ENABLE,docker lxd kubelet kube-proxy)
	@$(call add,DEFAULT_SERVICES_ENABLE,bind mysqld openvswitch)
	@$(call add,DEFAULT_SERVICES_ENABLE,rsyslogd systemd-journal-gatewayd)
	@$(call add,DEFAULT_SERVICES_DISABLE,powertop bridge gpm)
	@$(call add,DEFAULT_SERVICES_DISABLE,consolesaver)
	@$(call add,DEFAULT_SERVICES_DISABLE,ahttpd alteratord)
	@$(call add,DEFAULT_SERVICES_DISABLE,systemd-networkd systemd-resolved)
	@$(call add,DEFAULT_SERVICES_ENABLE,pve-manager pve-cluster pveproxy pvedaemon pvestatd \
		pve-firewall pvefw-logger pve-guests pve-ha-crm pve-ha-lrm spiceproxy \
		lxc lxcfs lxc-net lxc-monitord)

#	@$(call add,MAIN_GROUPS,server-v/141-cockpit $(cockpit))
#	@$(call add,MAIN_GROUPS,server-v/430-moosefs $(moosefs))
#	@$(call add,MAIN_GROUPS,server-v/ocfs2)
#	@$(call add,MAIN_GROUPS,server-v/120-openstack $(openstack))
#ifeq (,$(filter-out x86_64,$(ARCH)))
#	@$(call add,MAIN_GROUPS,server-v/openvz)
#endif

endif
