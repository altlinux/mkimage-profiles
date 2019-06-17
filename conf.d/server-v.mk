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

distro/server-v: nfs = $(addprefix server-v/,\
	nfs nfs-ganesha)

distro/server-v: opennebula = $(addprefix server-v/opennebula/,\
	flow gate gui node-kvm node-lxd server)

distro/server-v: openstack = $(addprefix server-v/openstack/,\
	block compute controller network storage)

distro/server-v: container = $(addprefix server-v/,\
	docker kubernetes rkt podman lxd)

distro/server-v: network = $(addprefix server-v/,\
	bird haproxy keepalived openvswitch freeipa-client)

distro/server-v: monitoring = $(addprefix server-v/,\
	zabbix-agent telegraf prometheus-node_exporter monit collectd nagios-nrpe)
# zabbix prometheus influxdb grafana

distro/server-v: backup = $(addprefix server-v/,\
	burp)

distro/server-v: logging = $(addprefix server-v/,\
	rsyslog-classic systemd-journal-remote)

distro/server-v: profiles = $(addprefix server-v/,\
	10-basic 20-pve 41-opennebula-node 42-opennebula-server 51-openstack-node 52-openstack-controller 61-docker)

distro/.server-v-base: distro/.installer use/syslinux/ui/menu use/memtest
	@$(call add,BASE_LISTS,server-base openssh)

distro/server-v: distro/.server-v-base \
	use/kernel/server use/init/systemd \
	use/services use/ntp/chrony \
	use/server/base use/branding/complete use/firmware \
	use/apt-conf/branch use/install2/repo \
	use/efi/shell +efi
	@$(call set,IMAGE_FLAVOUR,$(subst alt-9-,,$(IMAGE_NAME)))
	@$(call set,META_VOL_ID,ALT 9.0 Server-V $$(IMAGE_FLAVOUR)/$(ARCH))
	@$(call set,META_PUBLISHER,BaseALT Ltd)
	@$(call set,META_VOL_SET,ALT)
	@$(call set,META_VOL_ID,ALT 9.0 Server-V)
	@$(call set,META_APP_ID,$(DISTRO_VERSION)/$(ARCH))
	@$(call set,DOCS,alt-server)
	@$(call add,STAGE1_MODLISTS,stage2-mmc)
	@$(call set,INSTALLER,alt-server-v)
	@$(call add,INSTALL2_PACKAGES,alterator-notes)
	@$(call add,INSTALL2_PACKAGES,fdisk xfsprogs btrfs-progs)
	@$(call add,INSTALL2_PACKAGES,installer-feature-multipath)
	@$(call add,COMMON_PACKAGES,vim-console)
	@$(call add,SYSTEM_PACKAGES,mdadm-tool lvm2 multipath-tools vdo)
	@$(call add,BASE_KMODULES,ipset kvm xtables-addons kvdo)
	@$(call add,BASE_LISTS,virt/base.pkgs)
	@$(call add,MAIN_GROUPS,server-v/zfs)
	@$(call add,MAIN_GROUPS,server-v/10-basic server-v/kvm)
	@$(call add,MAIN_GROUPS,server-v/11-cockpit $(cockpit))
	@$(call add,MAIN_GROUPS,server-v/20-pve server-v/pve)
	@$(call add,MAIN_GROUPS,server-v/30-opennebula $(opennebula))
	@$(call add,MAIN_GROUPS,server-v/40-openstack $(openstack))
	@$(call add,MAIN_GROUPS,server-v/60-container $(container))
	@$(call add,MAIN_GROUPS,server-v/65-cluster server-v/corosync_pacemaker)
	@$(call add,MAIN_GROUPS,server-v/70-storage)
	@$(call add,MAIN_GROUPS,server-v/71-ceph $(ceph))
	@$(call add,MAIN_GROUPS,server-v/72-glusterfs $(glusterfs))
	@$(call add,MAIN_GROUPS,server-v/74-moosefs $(moosefs))
	@$(call add,MAIN_GROUPS,server-v/75-nfs $(nfs))
	@$(call add,MAIN_GROUPS,server-v/76-iscsi $(iscsi))
	@$(call add,MAIN_GROUPS,server-v/80-network $(network))
	@$(call add,MAIN_GROUPS,server-v/90-monitoring $(monitoring))
	@$(call add,MAIN_GROUPS,server-v/100-backup $(backup))
	@$(call add,MAIN_GROUPS,server-v/110-logging $(logging))
	@$(call add,THE_PROFILES,$(profiles) minimal)
	@$(call add,SERVICES_ENABLE,sshd)
	@$(call add,SERVICES_ENABLE,libvirtd)
	@$(call add,DEFAULT_SERVICES_ENABLE,getty@tty1 getty@ttyS0)
	@$(call add,DEFAULT_SERVICES_ENABLE,fstrim.timer)
	@$(call add,DEFAULT_SERVICES_DISABLE,powertop bridge gpm)
	@$(call add,DEFAULT_SERVICES_DISABLE,consolesaver)
	@$(call set,BRANDING,alt-server)
	@$(call add,THE_PACKAGES,alterator-fbi)
	@$(call add,THE_LISTS,$(call tags,server alterator))
	@$(call add,DEFAULT_SERVICES_DISABLE,ahttpd alteratord)

endif
