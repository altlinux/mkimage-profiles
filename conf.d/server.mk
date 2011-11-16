# server distributions
ifeq (distro,$(IMAGE_CLASS))

distro/server-base: distro/installer use/repo/main \
	use/syslinux/ui-menu use/memtest use/bootloader/grub
	@$(call add,BASE_LISTS,server-base)

distro/server-mini: distro/server-base use/cleanup/x11-alterator
	@$(call set,KFLAVOURS,el-smp)
	@$(call add,KMODULES,e1000e igb)
	@$(call add,BASE_LISTS,\
		$(call tags,base && (server || network || security || pkg)))
	@$(call add,BASE_LISTS,$(call tags,extra network))

distro/server-systemd: distro/server-mini use/systemd

distro/server-ovz: distro/server-mini \
	use/hdt use/rescue use/firmware/server use/power/acpi/button
	@$(call set,STAGE1_KFLAVOUR,std-def)
	@$(call set,KFLAVOURS,std-def ovz-el)
	@$(call add,KMODULES,bcmwl ndiswrapper rtl8168 rtl8192)
	@$(call add,KMODULES,ipset ipt-netflow opendpi pf_ring xtables-addons)
	@$(call add,KMODULES,drbd83 kvm)
	@$(call add,BASE_LISTS,ovz-server)
	@$(call add,MAIN_LISTS,kernel-wifi)
	@$(call add,MAIN_GROUPS,dns-server http-server ftp-server kvm-server)
	@$(call add,MAIN_GROUPS,ipmi mysql-server dhcp-server mail-server)
	@$(call add,MAIN_GROUPS,monitoring diag-tools)

endif
