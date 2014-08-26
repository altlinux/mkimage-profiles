# server distributions
ifeq (distro,$(IMAGE_CLASS))

distro/.server-base: distro/.installer use/syslinux/ui/menu use/memtest \
	use/cleanup/x11-alterator
	@$(call add,BASE_LISTS,server-base openssh)

distro/server-nano: distro/.server-base use/bootloader/lilo +power \
	use/install2/cleanup/crypto use/install2/cleanup/vnc
	@$(call add,BASE_LISTS,$(call tags,server network))
	@$(call add,BASE_PACKAGES,dhcpcd cpio)

distro/server-mini: distro/.server-base +net-eth \
	use/server/mini use/kernel/net use/efi use/power/acpi/button
	@$(call set,INSTALLER,altlinux-server)
	@$(call add,BASE_PACKAGES,make-initrd-mdadm make-initrd-lvm)

distro/server-ovz: distro/server-mini use/server/ovz use/server/groups/base \
	use/install2/net use/hdt use/rescue \
	use/firmware/server use/firmware/cpu +wireless; @:

distro/server-zabbix: distro/server-mini use/server/zabbix; @:

endif
