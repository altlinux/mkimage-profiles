# Simply Linux images

ifeq (distro,$(IMAGE_CLASS))

distro/slinux-live: distro/.base use/slinux/base use/slinux/live +live
	@$(call add,THE_LISTS,slinux/live-install)
	@$(call set,META_VOL_ID,Simply Linux live $(DISTRO_VERSION) $(ARCH))
	@$(call set,META_APP_ID,Simply Linux live $(DISTRO_VERSION) $(ARCH) $(shell date +%F))

distro/slinux: distro/.base use/slinux/full use/live/rescue use/live/repo \
	+live +live-installer-pkg use/live-install/oem
	@$(call set,INSTALLER,simply-linux)
	@$(call add,MAIN_GROUPS,slinux/emulators-full slinux/games-base slinux/games slinux/games-full slinux/graphics-base slinux/graphics slinux/graphics-full-inkscape slinux/multimedia-full-audacity slinux/multimedia-base slinux/multimedia-full-cheese slinux/multimedia slinux/multimedia-full-shotcut slinux/net-base)
ifneq (,$(filter-out riscv64,$(ARCH)))
	@$(call add,MAIN_GROUPS,slinux/multimedia-full-obs-studio)
endif
ifneq (,$(filter-out e2k% riscv64,$(ARCH)))
	@$(call add,MAIN_GROUPS,slinux/graphics-full-shotwell slinux/flatpak)
endif
	@$(call set,META_VOL_ID,Simply Linux $(DISTRO_VERSION) $(ARCH))
	@$(call set,META_APP_ID,Simply Linux $(DISTRO_VERSION) $(ARCH) $(shell date +%F))
endif

distro/slinux-bloat: distro/slinux use/slinux/live

ifeq (vm,$(IMAGE_CLASS))
vm/slinux:: use/slinux/vm-base use/auto-resize +vmguest; @:

ifeq (,$(filter-out aarch64 riscv64,$(ARCH)))
vm/slinux:: use/uboot
	@$(call add,BASE_LISTS,uboot)
endif

ifeq (,$(filter-out aarch64,$(ARCH)))
vm/slinux:: use/no-sleep use/arm-rpi4; @:
endif

ifeq (,$(filter-out aarch64,$(ARCH)))
vm/slinux-rpi: use/slinux/vm-base use/arm-rpi4/full; @:
endif

endif
