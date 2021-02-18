ifeq (distro,$(IMAGE_CLASS))

distro/alt-workstation: workstation_groups_x86 = $(addprefix workstation/,\
	3rdparty blender clamav cloud-clients freecad \
	gtk-dictionary kvm smartcard voip-clients)

distro/alt-workstation: distro/.base +vmguest +wireless +efi \
	mixin/desktop-installer mixin/alt-workstation \
	mixin/alt-workstation-install \
	use/memtest use/rescue/base use/bootloader/grub use/luks \
	use/efi/memtest86 use/efi/shell \
	use/install2/repo use/install2/suspend use/live/suspend \
	use/live/install use/live/x11 use/live/repo use/live/rw \
	use/vmguest/kvm/x11 use/stage2/kms \
	use/branding/complete use/docs/license \
	use/domain-client/full use/x11/amdgpu use/x11/lightdm/gtk \
	use/e2k/multiseat/801/full use/e2k/x11/101 use/e2k/sound/401
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call add,MAIN_GROUPS,$(workstation_groups_x86))
endif
ifeq (,$(filter-out x86_64,$(ARCH)))
	@$(call add,MAIN_GROUPS,workstation/virtualbox)
	@$(call add,BASE_KMODULES,kvm virtualbox)
endif
ifeq (,$(filter-out e2k%,$(ARCH)))
	@$(call add,THE_PACKAGES,python-module-serial)
	@$(call add,THE_PACKAGES,setup-mate-nocomposite)
	@$(call add,THE_PACKAGES,xorg-drv-smi)	# use/x11/smi
	@$(call add,MAIN_GROUPS,workstation/alterator-web)
	@$(call add,SERVICES_ENABLE,ahttpd)	# in case it gets installed
ifeq (,$(filter-out e2k,$(ARCH)))
	@$(call set,META_VOL_ID,ALT Workstation for Elbrus 401-PC)
endif	# e2k
ifeq (,$(filter-out e2kv4,$(ARCH)))
	@$(call set,META_VOL_ID,ALT Workstation for Elbrus 801/101-PC)
endif	# e2kv4
endif	# e2k%
	@$(call add,RESCUE_BOOTARGS,nomodeset vga=0)

endif	# distro

ifeq (vm,$(IMAGE_CLASS))

vm/.alt-workstation: vm/systemd use/x11/lightdm/gtk \
	use/oem/distro use/repo mixin/alt-workstation
	@$(call add,THE_PACKAGES,rootfs-installer-features)
	@$(call add,THE_PACKAGES,installer-feature-lightdm-stage3)
	@$(call add,THE_PACKAGES,installer-feature-quota-stage2)

vm/alt-workstation:: vm/.alt-workstation

ifeq (,$(filter-out aarch64 armh riscv64,$(ARCH)))
vm/alt-workstation:: use/uboot
	@$(call add,BASE_LISTS,uboot)
endif

ifeq (,$(filter-out aarch64 armh,$(ARCH)))
vm/alt-workstation-rpi: vm/.alt-workstation use/arm-rpi4/full; @:
endif

ifeq (,$(filter-out aarch64,$(ARCH)))
vm/alt-workstation-tegra: vm/.alt-workstation use/aarch64-tegra; @:
endif

ifeq (,$(filter-out armh,$(ARCH)))
vm/alt-workstation-mcom02: vm/.alt-workstation use/armh-mcom02/x11; @:
endif

ifeq (,$(filter-out mipsel,$(ARCH)))
vm/alt-workstation::
	@$(call add,THE_PACKAGES,mate-reduced-resource)

vm/alt-workstation-bfk3: vm/alt-workstation use/mipsel-bfk3/x11; @:
vm/alt-workstation-tavolga: vm/alt-workstation use/mipsel-mitx/x11; @:
endif

vm/alt-workstation-cloud: vm/alt-p9-cloud use/x11/lightdm/gtk \
	mixin/alt-workstation
	@$(call add,THE_PACKAGES,cloud-init-config-netplan)
	@$(call add,SYSTEMD_SERVICES_DISABLE,network.service)
endif
