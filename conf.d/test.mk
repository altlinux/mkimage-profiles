# debug/test/experimental images
ifneq (,$(DEBUG))

ifeq (distro,$(IMAGE_CLASS))

distro/syslinux-auto: distro/.init use/hdt use/syslinux/timeout/1; @:
distro/syslinux-noescape: distro/syslinux-auto use/syslinux/noescape.cfg; @:

distro/live-systemd: distro/.base use/live/base +systemd; @:
distro/live-plymouth: distro/.live-base use/plymouth/live; @:
distro/live-mediacheck: distro/.base use/mediacheck +plymouth; @:

distro/live-testserver: distro/live-install use/server/mini
	@$(call set,KFLAVOURS,std-def el-smp)

distro/live-gns3: distro/live-icewm
	@$(call add,LIVE_LISTS,gns3)
	@$(call add,LIVE_KMODULES,kvm virtualbox)

# NB: requires runtime Server/ServerActive setup in zabbix_agentd.conf
distro/live-zabbix: distro/live-icewm use/net-eth
	@$(call add,THE_PACKAGES,zabbix-agent)
	@$(call add,DEFAULT_SERVICES_ENABLE,zabbix_agentd)

distro/icewm-efi: distro/icewm use/efi/debug use/firmware
	@$(call add,INSTALL2_PACKAGES,strace)

distro/mate-kz: distro/regular-mate
	@$(call set,GLOBAL_BOOT_LANG,kk_KZ)
	@$(call add,LIVE_PACKAGES,hunspell-kk)

# a minimalistic systemd-based server installer
distro/server-systemd: distro/server-nano \
	use/install2/repo use/cleanup/x11-alterator use/net/networkd +systemd
	@$(call add,CLEANUP_PACKAGES,glib2 iw libpython libwireless)

distro/server-test: distro/server-mini use/relname
	@$(call set,RELNAME,Test-Server)

# something marginally useful (as a network-only installer)
# NB: doesn't carry stage3 thus cannot use/bootloader
distro/netinst: distro/.base use/install2/net; @:

distro/propagator-test: distro/.base use/mediacheck
	@$(call add,STAGE2_BOOTARGS,propagator-debug)

distro/desktop-luks: distro/icewm use/luks; @:
distro/desktop-systemd: distro/icewm +systemd; @:
distro/desktop-plymouth: distro/icewm +plymouth; @:
distro/server-efi: distro/server-mini use/efi/debug; @:

distro/server-zabbix: distro/server-mini use/server/zabbix use/net-eth

# a crop of images running stuff as PID 1
distro/bash: distro/.base use/pid1
	@$(call add,STAGE1_PACKAGES,bash)
	@$(call set,PID1_BIN,/bin/bash)

distro/vi: distro/.base use/pid1
	@$(call add,STAGE1_PACKAGES,vim-minimal)
	@$(call set,PID1_BIN,/bin/vi)

distro/emacs: distro/.base use/pid1
	@$(call add,STAGE1_PACKAGES,mg)
	@$(call set,PID1_BIN,/usr/bin/mg)

distro/elinks: distro/.base use/pid1/net
	@$(call add,STAGE1_PACKAGES,elinks)
	@$(call set,PID1_BIN,/usr/bin/elinks)

endif # IMAGE_CLASS: distro

ifeq (ve,$(IMAGE_CLASS))

ifeq (centos,$(REPO))

ve/.centos-base: ve/.bare
	@$(call set,IMAGE_INIT_LIST,hasher-pkg-init)

ve/centos: ve/.centos-base
	@$(call add,BASE_PACKAGES,openssh-server)

endif # REPO: centos

ifeq (opensuse,$(REPO))

ve/.opensuse-base: ve/.bare
	@$(call set,IMAGE_INIT_LIST,hasher-pkg-init)
	@$(call add,BASE_PACKAGES,aaa_base)

endif # REPO: opensuse

endif # IMAGE_CLASS: ve

ifeq (vm,$(IMAGE_CLASS))

vm/net-static: vm/bare use/net-eth use/net-ssh
	@$(call add,NET_ETH,eth0:static:10.0.2.16/24:10.0.2.2)

endif # IMAGE_CLASS: vm

endif
