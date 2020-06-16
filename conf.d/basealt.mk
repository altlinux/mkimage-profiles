ifeq (distro,$(IMAGE_CLASS))

ifeq (,$(filter-out i586 x86_64,$(ARCH)))
distro/alt-workstation: workstation_groups_x86 = $(addprefix workstation/,\
	3rdparty blender clamav cloud-clients freecad \
	gtk-dictionary kvm smartcard voip-clients)
endif

distro/alt-workstation: distro/.base +vmguest +wireless +efi \
	mixin/desktop-installer mixin/alt-workstation \
	mixin/alt-workstation-install \
        use/memtest use/rescue/base use/bootloader/grub use/luks \
        use/efi/refind use/efi/memtest86 use/efi/shell \
	use/install2/repo use/install2/suspend use/live/suspend \
        use/live/install use/live/x11 use/live/repo use/live/rw \
        use/vmguest/kvm/x11 use/stage2/kms \
	use/branding/complete use/docs/license \
        use/domain-client/full use/x11/amdgpu use/x11/lightdm/gtk
	@$(call add,INSTALL2_PACKAGES,open-iscsi)
	@$(call add,INSTALL2_PACKAGES,xorg-conf-libinput-touchpad)
	@$(call add,INSTALL2_PACKAGES,installer-feature-quota-stage2)
	@$(call add,MAIN_PACKAGES,solaar)
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call add,MAIN_GROUPS,$(workstation_groups_x86))
endif
ifeq (,$(filter-out x86_64,$(ARCH)))
	@$(call add,MAIN_GROUPS,workstation/virtualbox)
	@$(call add,BASE_KMODULES,kvm virtualbox)
endif
ifeq (,$(filter-out aarch64,$(ARCH)))
	@$(call set,KFLAVOURS,bmitx-def std-def)
	@$(call add,INSTALL2_PACKAGES,installer-feature-cleanup-kernel-stage3)
	@$(call add,LIVE_PACKAGES,installer-feature-cleanup-kernel-stage3)
endif
	@$(call add,MAIN_LISTS,workstation/extras)
	@$(call add,MAIN_LISTS,$(call tags,xorg vaapi))
	@$(call add,THE_LISTS,$(call tags,archive extra))
	@$(call add,THE_LISTS,$(call tags,mobile mate))
	@$(call add,LIVE_PACKAGES,installer-feature-quota-stage2)
	@$(call add,LIVE_PACKAGES,livecd-installer-features)
	@$(call add,LIVE_PACKAGES,installer-feature-lightdm-stage3)
	@$(call add,RESCUE_BOOTARGS,nomodeset vga=0)
	@$(call add,EFI_BOOTARGS,lang=ru_RU)

ifeq (,$(filter-out e2k%,$(ARCH)))
distro/.alt-workstation-base: distro/.e2k-installer mixin/alt-workstation
	@$(call add,THE_PACKAGES,setup-mate-terminal)
	@$(call add,THE_PACKAGES,setup-mate-nocomposite)
	@$(call add,THE_PACKAGES,setup-libgl-dri3-disable)
	@$(call add,THE_PACKAGES,setup-pulseaudio-plain-module-detect)
	@$(call add,THE_PACKAGES,firmware-linux)
	@$(call add,THE_BRANDING,graphics)
	@$(call set,META_APP_ID,ALT Workstation/$(ARCH))

distro/.alt-workstation: distro/.alt-workstation-base use/x11/lightdm/gtk; @:

distro/alt-workstation-101: distro/.alt-workstation use/e2k/101
	@$(call set,META_VOL_ID,ALT Workstation 101)
	@$(call add,MAIN_GROUPS,workstation/e101-modesetting)
	@$(call add,MAIN_GROUPS,workstation/e101-mga2)

distro/alt-workstation-401: distro/.alt-workstation use/e2k/401; @:
	@$(call set,META_VOL_ID,ALT Workstation 401)

# avoid lightdm; NB: mate-settings pulls it in (hence the dummy)
distro/alt-workstation-801: distro/.alt-workstation-base use/e2k/install2/801
	@$(call set,META_VOL_ID,ALT Workstation 801)
	@$(call add,MAIN_GROUPS,workstation/e801-1seat workstation/e801-2seat)
	@$(call add,INSTALL2_PACKAGES,installer-feature-e2k-801-dualseat)
endif

endif

ifeq (vm,$(IMAGE_CLASS))
ifeq (,$(filter-out aarch64 armh,$(ARCH)))

vm/alt-workstation: vm/systemd use/x11/armsoc use/x11/lightdm/gtk \
	use/oem use/repo use/bootloader/uboot mixin/alt-workstation
	@$(call add,THE_PACKAGES,rootfs-installer-features)
	@$(call add,THE_PACKAGES,installer-feature-lightdm-stage3)
	@$(call add,THE_PACKAGES,installer-feature-quota-stage2)

vm/alt-workstation-tegra: vm/alt-workstation use/aarch64-tegra; @:

endif
vm/alt-workstation-cloud: vm/alt-p9-cloud use/x11/lightdm/gtk \
	mixin/alt-workstation
	@$(call add,THE_PACKAGES,cloud-init-config-netplan)
endif
