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

distro/ltsp-icewm: distro/icewm use/ltsp use/firmware
	@$(call add,BASE_LISTS,$(call tags,base network))
	@$(call add,BASE_LISTS,ltsp)
	@$(call add,BASE_PACKAGES,apt-repo)

distro/desktop-systemd: distro/icewm use/systemd

endif
