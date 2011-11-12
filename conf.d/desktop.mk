# desktop distributions
ifeq (distro,$(IMAGE_CLASS))

distro/desktop-base: distro/installer sub/main \
	use/syslinux/ui-vesamenu use/x11/xorg use/bootloader/grub

distro/icewm: distro/desktop-base \
	use/lowmem use/x11/xdm use/x11/runlevel5 \
	use/bootloader/lilo use/power/acpi/button \
	use/cleanup/alterator
	@$(call add,BASE_LISTS,$(call tags,icewm desktop))

distro/desktop-systemd: distro/icewm use/systemd

endif
