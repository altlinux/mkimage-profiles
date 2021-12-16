ifeq (distro,$(IMAGE_CLASS))

distro/alt-workstation: workstation_groups_x86 = $(addprefix workstation/,\
	3rdparty kvm clamav cloud-clients freecad \
	gtk-dictionary smartcard voip-clients vlc)

distro/alt-workstation: distro/.base +vmguest +wireless +efi \
	mixin/desktop-installer mixin/alt-workstation \
	mixin/alt-workstation-install \
	use/memtest use/rescue use/bootloader/grub use/luks \
	use/efi/memtest86 use/efi/shell \
	use/install2/repo use/install2/suspend use/live/suspend \
	use/live/install use/live/x11 use/live/repo use/live/rw \
	use/vmguest/kvm/x11 use/stage2/kms \
	use/branding/complete use/docs/license \
	use/domain-client/full use/x11/amdgpu use/x11/lightdm/gtk \
	use/e2k/multiseat/full use/e2k/x11/101 use/e2k/sound/401
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call add,MAIN_GROUPS,$(workstation_groups_x86))
	@$(call add,LIVE_LISTS,workstation/vlc)
endif
ifeq (,$(filter-out x86_64,$(ARCH)))
	@$(call add,MAIN_GROUPS,workstation/blender)
	@$(call add,MAIN_GROUPS,workstation/virtualbox)
	@$(call add,BASE_KMODULES,kvm virtualbox)
endif
ifeq (,$(filter-out aarch64 armh riscv64,$(ARCH)))
	@$(call add,MAIN_GROUPS,workstation/celluloid)
	@$(call add,LIVE_LISTS,workstation/celluloid)
endif
ifeq (,$(filter-out e2k%,$(ARCH)))
	@$(call add,THE_PACKAGES,python-module-serial)
	@$(call add,THE_PACKAGES,setup-mate-nocomposite)
	@$(call add,THE_PACKAGES,xorg-drv-smi)	# use/x11/smi
	@$(call add,THE_PACKAGES,flashrom)
	@$(call add,MAIN_PACKAGES,alterator-secsetup)
	@$(call add,MAIN_GROUPS,workstation/alterator-web)
	@$(call add,SERVICES_ENABLE,ahttpd)	# in case it gets installed
ifeq (,$(filter-out e2k,$(ARCH)))
	@$(call set,META_VOL_ID,ALT Workstation for Elbrus 401-PC)
endif	# e2k
ifeq (,$(filter-out e2kv4,$(ARCH)))
	@$(call set,META_VOL_ID,ALT Workstation for Elbrus 801/101-PC)
endif	# e2kv4
ifeq (,$(filter-out e2kv5,$(ARCH)))
	@$(call set,META_VOL_ID,ALT Workstation for Elbrus 901-PC)
endif	# e2kv5
endif	# e2k%
	@$(call add,RESCUE_BOOTARGS,nomodeset vga=0)

endif	# distro

ifeq (vm,$(IMAGE_CLASS))

vm/.alt-workstation: vm/systemd use/x11/lightdm/gtk \
	use/oem/distro use/repo mixin/alt-workstation
	@$(call add,THE_PACKAGES,installer-feature-lightdm-stage3)
	@$(call add,THE_PACKAGES,installer-feature-quota-stage2)
	@$(call add,THE_PACKAGES,alterator-gpupdate)
ifeq (,$(filter-out armh,$(ARCH)))
	@$(call add,THE_LISTS,workstation/libreoffice-latest)
else
	@$(call add,THE_LISTS,workstation/libreoffice)
endif

vm/alt-workstation:: vm/.alt-workstation
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call add,THE_LISTS,workstation/vlc)
endif

ifeq (,$(filter-out aarch64 armh riscv64,$(ARCH)))
vm/alt-workstation:: use/uboot
	@$(call add,BASE_LISTS,uboot)
	@$(call add,THE_LISTS,workstation/celluloid)
endif

ifeq (,$(filter-out aarch64 armh,$(ARCH)))
vm/alt-workstation:: use/no-sleep use/arm-rpi4; @:
endif

ifeq (,$(filter-out aarch64 armh,$(ARCH)))
vm/alt-workstation-rpi: vm/.alt-workstation use/arm-rpi4/full
	@$(call add,THE_LISTS,workstation/celluloid)
	@$(call set,THE_BROWSER,chromium)
	@$(call add,THE_PACKAGES,chromium firefox-esr-ru-)
endif

ifeq (,$(filter-out aarch64,$(ARCH)))
vm/alt-workstation-tegra: vm/.alt-workstation use/aarch64-tegra
	@$(call add,THE_LISTS,workstation/vlc)
endif

ifeq (,$(filter-out armh,$(ARCH)))
vm/alt-workstation-mcom02: vm/.alt-workstation use/armh-mcom02/x11
	@$(call add,THE_LISTS,workstation/celluloid)
endif

ifeq (,$(filter-out mipsel,$(ARCH)))
vm/alt-workstation::
	@$(call add,THE_PACKAGES,mate-reduced-resource)
	@$(call add,THE_LISTS,workstation/celluloid)

vm/alt-workstation-bfk3: vm/alt-workstation use/mipsel-bfk3/x11; @:
vm/alt-workstation-tavolga: vm/alt-workstation use/mipsel-mitx/x11; @:
endif

vm/alt-workstation-cloud: vm/cloud-systemd use/x11/lightdm/gtk \
	mixin/alt-workstation
	@$(call add,THE_PACKAGES,cloud-init-config-netplan)
	@$(call add,SYSTEMD_SERVICES_DISABLE,network.service)
endif
