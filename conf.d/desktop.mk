# desktop distributions
ifeq (distro,$(IMAGE_CLASS))

distro/.desktop-base: distro/.installer use/syslinux/ui/vesamenu use/x11/xorg
	@$(call set,INSTALLER,desktop)

distro/.desktop-mini: distro/.desktop-base use/x11/xdm; @:

distro/.desktop-network: distro/.desktop-mini mixin/desktop-installer; @:

#distro/icewm: distro/.desktop-network use/lowmem use/install2/fs +icewm; @:
#distro/ltsp-icewm: distro/icewm +ltsp; @:

# check OEM mode install (without DE)
distro/install-oem: distro/.regular-install-x11-systemd use/install2/oem
	@$(call add,STAGE2_BOOTARGS,oem oem_initrd)

endif
