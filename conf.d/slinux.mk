# Simply Linux images

ifeq (distro,$(IMAGE_CLASS))

distro/slinux-live: distro/.livecd-install use/slinux/base use/slinux/live
	@$(call add,THE_LISTS,slinux/live-install)
	@$(call set,META_VOL_ID,Simply Linux live $(DISTRO_VERSION) $(ARCH))
	@$(call set,META_APP_ID,Simply Linux live $(DISTRO_VERSION) $(ARCH) $(shell date +%F))

distro/slinux: distro/.installer use/slinux/full use/rescue/base
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

ifeq (,$(filter-out aarch64 armh riscv64,$(ARCH)))
vm/slinux:: use/uboot
	@$(call add,BASE_LISTS,uboot)
endif

ifeq (,$(filter-out aarch64 armh,$(ARCH)))
vm/slinux:: use/no-sleep use/arm-rpi4; @:
endif

ifeq (,$(filter-out aarch64 armh,$(ARCH)))
vm/slinux-rpi: use/slinux/vm-base use/arm-rpi4/full; @:
endif

ifeq (,$(filter-out armh,$(ARCH)))
vm/slinux-mcom02: use/slinux/vm-base use/armh-mcom02/x11; @:
endif

ifeq (,$(filter-out mipsel,$(ARCH)))
vm/slinux::
	@$(call add,THE_PACKAGES,installer-feature-bell-off-stage3)
	@$(call add,THE_PACKAGES,xfce-reduced-resource)

vm/slinux-tavolga: vm/slinux use/mipsel-mitx/x11; @:
vm/slinux-bfk3: vm/slinux use/mipsel-bfk3/x11; @:
endif

endif
