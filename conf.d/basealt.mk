ifeq (distro,$(IMAGE_CLASS))

distro/alt-workstation: workstation_groups_x86 = $(addprefix workstation/,\
	3rdparty clamav cloud-clients freecad \
	gtk-dictionary smartcard voip-clients)

ifneq (,$(filter-out e2k%,$(ARCH)))
distro/alt-workstation: mediaplayer = workstation/showtime
else
distro/alt-workstation: mediaplayer = workstation/smplayer
endif

distro/alt-workstation:: distro/.base +vmguest +wireless +efi \
	mixin/desktop-installer mixin/alt-workstation \
	mixin/alt-workstation-install \
	use/memtest use/live/rescue use/bootloader/grub use/luks \
	use/efi/shell use/live/suspend \
	use/live/x11 use/live/repo use/live/rw \
	use/vmguest/kvm/x11 use/stage2/kms \
	use/branding/complete use/docs/license \
	use/domain-client/full use/x11/amdgpu \
	use/firmware/laptop \
	use/e2k/multiseat/full use/e2k/x11/101 use/e2k/sound/401
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call add,MAIN_GROUPS,$(workstation_groups_x86))
endif
ifeq (,$(filter-out x86_64,$(ARCH)))
	@$(call add,MAIN_GROUPS,workstation/blender)
	@$(call add,MAIN_GROUPS,workstation/yandex-browser)
endif
	@$(call add,MAIN_GROUPS,workstation/gnome-boxes)
	@$(call add,MAIN_GROUPS,workstation/fractal)
ifeq (,$(filter-out x86_64 aarch64,$(ARCH)))
	@$(call add,MAIN_GROUPS,workstation/flatpak)
	@$(call add,MAIN_GROUPS,workstation/daily-planner)
	@$(call add,MAIN_GROUPS,workstation/kvm)
endif
ifeq (,$(filter-out p11,$(BRANCH)))
ifeq (,$(filter-out aarch64,$(ARCH)))
	@$(call set,KFLAVOURS,6.6 6.12)
endif
endif
ifeq (,$(filter-out e2k%,$(ARCH)))
	@$(call add,THE_PACKAGES,python-module-serial)
	@$(call add,THE_PACKAGES,xorg-drv-smi)	# use/x11/smi
	@$(call add,THE_PACKAGES,flashrom)
	@$(call add,MAIN_PACKAGES,alterator-secsetup)
ifeq (,$(filter-out e2k,$(ARCH)))
	@$(call set,META_VOL_ID,ALT Workstation for Elbrus v3 (401-PC))
endif	# e2k
ifeq (,$(filter-out e2kv4,$(ARCH)))
	@$(call set,META_VOL_ID,ALT Workstation for Elbrus v4 (801/101-PC))
endif	# e2kv4
ifeq (,$(filter-out e2kv5,$(ARCH)))
	@$(call set,META_VOL_ID,ALT Workstation for Elbrus v5 (901-PC))
endif	# e2kv5
ifeq (,$(filter-out e2kv6,$(ARCH)))
	@$(call set,META_VOL_ID,ALT Workstation for Elbrus v6 (201-PC))
endif	# e2kv6
endif	# e2k%
	@$(call add,MAIN_GROUPS,$(mediaplayer))
	@$(call add,LIVE_LISTS,$(mediaplayer))
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call add,RESCUE_BOOTARGS,nomodeset)
endif

ifeq (,$(filter-out e2k%,$(ARCH)))
distro/alt-workstation:: +power; @:
endif

endif	# distro

ifeq (vm,$(IMAGE_CLASS))

vm/.alt-workstation: vm/systemd \
	use/oem/distro use/repo mixin/alt-workstation
	@$(call add,THE_PACKAGES,installer-feature-quota-stage2)
	@$(call add,THE_PACKAGES,alterator-gpupdate)
	@$(call add,THE_LISTS,workstation/libreoffice)

vm/alt-workstation: vm/.alt-workstation mixin/vm-archdep +vmguest
	@$(call add,THE_LISTS,$(mediaplayer))

ifeq (,$(filter-out aarch64,$(ARCH)))
vm/alt-workstation-rpi: vm/.alt-workstation use/arm-rpi4/full; @:
endif

vm/alt-workstation-cloud: vm/systemd use/repo \
	mixin/alt-workstation mixin/cloud-init use/vmguest/kvm use/tty/S0
	@$(call add,THE_PACKAGES,cloud-init-config-network-manager)
	@$(call add,THE_KMODULES,drm)
	@$(call add,VM_INITRDMODULES,sr_mod)
	@$(call add,BASE_PACKAGES,systemd-settings-disable-kill-user-processes)
	@$(call add,DEFAULT_SERVICES_ENABLE,getty@tty1 getty@ttyS0)
	@$(call add,DEFAULT_SERVICES_DISABLE,consolesaver)
endif
