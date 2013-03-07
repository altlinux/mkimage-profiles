# server distributions
ifeq (distro,$(IMAGE_CLASS))

distro/.server-base: distro/.installer use/syslinux/ui/menu use/memtest
	@$(call add,BASE_LISTS,server-base openssh)

distro/server-nano: distro/.server-base \
	use/cleanup/x11-alterator use/bootloader/lilo +power
	@$(call add,BASE_LISTS,$(call tags,server network))
	@$(call add,BASE_PACKAGES,dhcpcd cpio)

distro/server-mini: distro/.server-base use/server/mini use/kernel/net \
	use/cleanup/x11-alterator use/efi use/stage2/net-eth
	@$(call add,BASE_PACKAGES,make-initrd-mdadm make-initrd-lvm)

distro/server-ovz: distro/server-mini use/install2/net use/hdt use/rescue \
	use/firmware/server use/firmware/cpu use/power/acpi/button +wireless
	@$(call set,STAGE1_KFLAVOUR,std-def)
	@$(call set,KFLAVOURS,std-def ovz-el)
	@$(call add,MAIN_KMODULES,ipset ipt-netflow opendpi pf_ring)
	@$(call add,MAIN_KMODULES,xtables-addons)	# t6/branch
	@$(call add,MAIN_KMODULES,drbd83 kvm)
	@$(call add,BASE_LISTS,ovz-server)
	@$(call add,MAIN_GROUPS,dns-server http-server ftp-server kvm-server)
	@$(call add,MAIN_GROUPS,ipmi mysql-server dhcp-server mail-server)
	@$(call add,MAIN_GROUPS,monitoring diag-tools)

endif
