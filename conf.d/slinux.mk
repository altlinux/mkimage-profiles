# Simply Linux images

ifeq (distro,$(IMAGE_CLASS))

distro/slinux-live: distro/.livecd-install use/slinux/base
	@$(call add,THE_LISTS,slinux/live-install)
	@$(call set,META_VOL_ID,Simply Linux live $(DISTRO_VERSION) $(ARCH))
	@$(call set,META_APP_ID,Simply Linux live $(DISTRO_VERSION) $(ARCH) $(shell date +%F))

distro/slinux: distro/.installer use/slinux/full use/rescue/base
	@$(call set,INSTALLER,simply-linux)
	@$(call add,MAIN_GROUPS,slinux/dropbox slinux/emulators-full slinux/games-base slinux/games slinux/games-full slinux/graphics-base slinux/graphics-full-blender slinux/graphics slinux/graphics-full-inkscape slinux/graphics-full-shotwell slinux/graphics-full-synfigstudio slinux/multimedia-full-audacity slinux/multimedia-base slinux/multimedia-full-cheese slinux/multimedia slinux/multimedia-full-pitivi slinux/multimedia-full-sound-juicer slinux/comm-base)
	@$(call set,META_VOL_ID,Simply Linux $(DISTRO_VERSION) $(ARCH))
	@$(call set,META_APP_ID,Simply Linux $(DISTRO_VERSION) $(ARCH) $(shell date +%F))
endif

ifeq (vm,$(IMAGE_CLASS))
ifeq (,$(filter-out aarch64 armh,$(ARCH)))
vm/slinux: use/slinux/vm-base use/bootloader/uboot; @:

vm/slinux-tegra: use/slinux/vm-base use/aarch64-tegra; @:
endif
endif
