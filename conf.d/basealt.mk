ifeq (distro,$(IMAGE_CLASS))

ifeq (,$(filter-out i586 x86_64,$(ARCH)))
distro/alt-workstation: workstation_groups_x86 = $(addprefix workstation/,\
	3rdparty blender clamav cloud-clients freecad gnome-peer-to-peer \
	gtk-dictionary kvm smartcard virtualbox voip-clients)

distro/alt-workstation: distro/.base +power +vmguest +wireless +efi \
	mixin/desktop-installer mixin/alt-workstation \
        use/memtest use/rescue/base use/bootloader/grub use/luks \
        use/efi/refind use/efi/memtest86 use/efi/shell \
	use/install2/repo use/install2/suspend use/live/suspend \
        use/live/install use/live/x11 use/live/repo use/live/rw \
	use/branding/complete use/docs/license \
        use/domain-client/full use/x11/amdgpu
	@$(call add,INSTALL2_PACKAGES,open-iscsi)
	@$(call add,INSTALL2_PACKAGES,xorg-conf-synaptics)
	@$(call add,MAIN_PACKAGES,solaar)
	@$(call add,MAIN_GROUPS,$(workstation_groups_x86))
	@$(call add,MAIN_LISTS,workstation/extras)
	@$(call add,MAIN_LISTS,$(call tags,xorg vaapi))
	@$(call add,THE_LISTS,$(call tags,archive extra))
	@$(call add,THE_LISTS,$(call tags,mobile mate))
	@$(call add,BASE_KMODULES,kvm virtualbox)
	@$(call add,CLEANUP_BASE_PACKAGES,acpid-events-power)
	@$(call add,RESCUE_BOOTARGS,nomodeset vga=0)
	@$(call add,EFI_BOOTARGS,lang=ru_RU)
endif

ifeq (,$(filter-out e2k%,$(ARCH)))
distro/.alt-workstation: distro/.e2k-installer mixin/alt-workstation
	@$(call add,THE_PACKAGES,setup-mate-terminal)
	@$(call add,THE_PACKAGES,setup-mate-nocomposite)
	@$(call add,THE_PACKAGES,firmware-linux)

distro/alt-workstation-101: distro/.alt-workstation use/e2k/101; @:
distro/alt-workstation-401: distro/.alt-workstation use/e2k/401; @:
distro/alt-workstation-801: distro/.alt-workstation use/e2k/801; @:
endif

endif
