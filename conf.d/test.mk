# debug/test/experimental images
ifneq (,$(DEBUG))

ifeq (distro,$(IMAGE_CLASS))

distro/syslinux-auto: distro/.init use/hdt use/syslinux/timeout/1; @:
distro/syslinux-noescape: distro/syslinux-auto use/syslinux/noescape.cfg; @:

distro/live-systemd: distro/.base use/live/base use/systemd; @:
distro/live-plymouth: distro/.live-base use/plymouth/live; @:

distro/live-isomd5sum: distro/.base use/live/base use/isomd5sum
	@$(call add,LIVE_PACKAGES,livecd-isomd5sum)

distro/live-testserver: distro/live-install use/server/mini
	@$(call set,KFLAVOURS,std-def el-smp)

distro/live-gns3: distro/live-icewm
	@$(call add,LIVE_LISTS,gns3)
	@$(call add,LIVE_KMODULES,kvm virtualbox)

distro/icewm-efi: distro/icewm use/efi/debug use/firmware
	@$(call add,INSTALL2_PACKAGES,strace)

distro/server-systemd: distro/server-mini use/systemd
	@$(call set,KFLAVOURS,std-def)

distro/server-test: distro/server-mini use/relname
	@$(call set,RELNAME,Test-Server)

# tiny network-only server-ovz installer (stage2 comes over net too)
distro/server-ovz-netinst: distro/.base sub/stage1 use/stage2 \
	use/syslinux/ui/menu use/syslinux/localboot.cfg use/memtest
	@$(call add,SYSLINUX_CFG,netinstall2)

distro/desktop-luks: distro/icewm use/luks; @:
distro/desktop-systemd: distro/icewm use/systemd; @:
distro/desktop-plymouth: distro/icewm +plymouth; @:
distro/live-mate-systemd: distro/live-mate use/systemd use/live/install; @:
distro/server-efi: distro/server-mini use/efi/debug; @:

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

vm/net-static: vm/bare use/vm-net/static use/vm-ssh
	@$(call set,VM_NET_IPV4ADDR,10.0.2.16/24)
	@$(call set,VM_NET_IPV4GW,10.0.2.2)

endif # IMAGE_CLASS: vm

endif
