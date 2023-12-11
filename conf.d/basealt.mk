ifeq (distro,$(IMAGE_CLASS))

distro/alt-workstation: workstation_groups_x86 = $(addprefix workstation/,\
	3rdparty kvm clamav cloud-clients freecad \
	gtk-dictionary smartcard voip-clients)

ifeq (,$(filter-out i586 x86_64,$(ARCH)))
distro/alt-workstation: mediaplayer = workstation/vlc
endif
ifeq (,$(filter-out aarch64 armh mipsel riscv64,$(ARCH)))
distro/alt-workstation: mediaplayer = workstation/celluloid
endif
ifeq (,$(filter-out e2k%,$(ARCH)))
distro/alt-workstation: mediaplayer = workstation/smplayer
endif

distro/alt-workstation: distro/.base +vmguest +wireless +efi \
	mixin/desktop-installer mixin/alt-workstation \
	mixin/alt-workstation-install \
	use/memtest use/rescue use/bootloader/grub use/luks \
	use/efi/shell \
	use/install2/repo use/install2/suspend use/live/suspend \
	use/live/install use/live/x11 use/live/repo use/live/rw \
	use/vmguest/kvm/x11 use/stage2/kms \
	use/branding/complete use/docs/license \
	use/domain-client/full use/x11/amdgpu use/x11/lightdm/gtk \
	use/firmware/laptop \
	use/e2k/multiseat/full use/e2k/x11/101 use/e2k/sound/401
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call set,BOOTLOADER,grubpcboot)
endif
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call add,MAIN_GROUPS,$(workstation_groups_x86))
endif
ifeq (,$(filter-out x86_64,$(ARCH)))
	@$(call add,MAIN_GROUPS,workstation/blender)
	@$(call add,MAIN_GROUPS,workstation/virtualbox)
	@$(call add,BASE_KMODULES,kvm virtualbox)
endif
ifeq (,$(filter-out i586 x86_64 aarch64,$(ARCH)))
	@$(call add,MAIN_GROUPS,workstation/flatpak)
endif
ifeq (,$(filter-out e2k%,$(ARCH)))
	@$(call add,THE_PACKAGES,python-module-serial)
	@$(call add,THE_PACKAGES,setup-mate-nocomposite)
	@$(call add,THE_PACKAGES,xorg-drv-smi)	# use/x11/smi
	@$(call add,THE_PACKAGES,flashrom)
	@$(call add,MAIN_PACKAGES,alterator-secsetup)
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
	@$(call add,MAIN_GROUPS,$(mediaplayer))
	@$(call add,LIVE_LISTS,$(mediaplayer))
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

vm/alt-workstation:: vm/.alt-workstation  +vmguest
	@$(call add,THE_LISTS,$(mediaplayer))

ifeq (,$(filter-out aarch64 armh riscv64,$(ARCH)))
vm/alt-workstation:: use/uboot
	@$(call add,BASE_LISTS,uboot)
endif

ifeq (,$(filter-out aarch64 armh,$(ARCH)))
vm/alt-workstation:: use/no-sleep use/arm-rpi4; @:
endif

ifeq (,$(filter-out aarch64 armh,$(ARCH)))
vm/alt-workstation-rpi: vm/.alt-workstation use/arm-rpi4/full
	@$(call add,THE_LISTS,workstation/celluloid)
	@$(call set,THE_BROWSER,chromium)
endif

ifeq (,$(filter-out mipsel,$(ARCH)))
vm/alt-workstation::
	@$(call add,THE_PACKAGES,mate-reduced-resource)
	@$(call add,THE_LISTS,workstation/celluloid)

vm/alt-workstation-bfk3: vm/alt-workstation use/mipsel-bfk3/x11; @:
vm/alt-workstation-tavolga: vm/alt-workstation use/mipsel-mitx/x11; @:
endif

vm/alt-workstation-cloud: vm/systemd use/x11/lightdm/gtk use/repo \
	mixin/alt-workstation mixin/cloud-init use/vmguest/kvm use/tty/S0
	@$(call add,THE_PACKAGES,cloud-init-config-network-manager)
	@$(call add,THE_KMODULES,drm)
	@$(call add,VM_INITRDMODULES,sr_mod)
	@$(call add,BASE_PACKAGES,systemd-settings-disable-kill-user-processes)
	@$(call add,DEFAULT_SERVICES_ENABLE,getty@tty1 getty@ttyS0)
	@$(call add,DEFAULT_SERVICES_DISABLE,consolesaver)
endif
