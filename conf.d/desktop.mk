# desktop distributions
ifeq (distro,$(IMAGE_CLASS))

distro/desktop-base: distro/installer use/repo/main \
	use/syslinux/ui-vesamenu use/x11/xorg use/bootloader/grub
	@$(call set,INSTALLER,desktop)

distro/desktop-mini: distro/desktop-base \
	use/lowmem use/x11/xdm use/bootloader/lilo \
	use/power/acpi/button use/cleanup/alterator

distro/icewm: distro/desktop-mini
	@$(call add,BASE_LISTS,$(call tags,icewm desktop))

distro/desktop-systemd: distro/icewm use/systemd

endif
