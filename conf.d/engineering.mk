mixin/alt-engineering-install: engineering_groups = $(addprefix engineering/,\
	05-apps 2d-cad 3d-cad 3d-printer apcs cam eda misc)

mixin/alt-engineering-live: engineering_lists = $(addprefix engineering/,\
	2d-cad 3d-cad 3d-printer apcs cam eda misc)

mixin/alt-engineering: mixin/regular-desktop mixin/regular-mate \
	use/x11/lightdm/gtk \
	use/l10n +systemd +systemd-optimal +nm-gtk +plymouth
	@$(call add,THE_PACKAGES,theme-mate-windows)

mixin/alt-engineering-install: mixin/alt-engineering
	@$(call add,MAIN_GROUPS,$(engineering_groups))
ifeq (,$(filter-out i586 x86_64 aarch64,$(ARCH)))
	@$(call add,MAIN_GROUPS,engineering/cnc)
endif
ifeq (,$(filter-out x86_64,$(ARCH)))
	@$(call add,MAIN_KFLAVOURS,rt)
endif
	@$(call add,THE_PROFILES,engineering/00-minimal)
	@$(call add,THE_PROFILES,engineering/10-design)
	@$(call add,THE_PROFILES,engineering/20-automations)

mixin/alt-engineering-live: mixin/alt-engineering \
	use/live/ru use/live/rw use/live/desktop
	@$(call add,LIVE_LISTS,$(engineering_lists))
ifeq (,$(filter-out i586 x86_64 aarch64,$(ARCH)))
	@$(call add,LIVE_LISTS,engineering/cnc)
endif

ifeq (distro,$(IMAGE_CLASS))
distro/regular-engineering-live: distro/.regular-x11 \
	mixin/alt-engineering-live; @:

distro/regular-engineering-install: distro/.regular-install-x11 \
	mixin/alt-engineering-install; @:
endif

ifeq (vm,$(IMAGE_CLASS))
vm/regular-engineering: vm/.regular-desktop mixin/alt-engineering-install \
	use/oem/install; @:
endif
