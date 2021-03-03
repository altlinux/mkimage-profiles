mixin/alt-engineering-install: engineering_groups = $(addprefix engineering/,\
	05-apps 2d-cad 3d-cad 3d-printer apcs cam cnc eda scada)

mixin/alt-engineering-live: engineering_lists = $(addprefix engineering/,\
	2d-cad 3d-cad 3d-printer apcs cam cnc eda scada misc)

mixin/alt-engineering: mixin/regular-mate use/x11/lightdm/gtk \
	+systemd +systemd-optimal mixin/p9
	@$(call add,THE_PACKAGES,theme-mate-windows)

mixin/alt-engineering-install: mixin/alt-engineering
	@$(call add,MAIN_GROUPS,$(engineering_groups))
	@$(call add,MAIN_KFLAVOURS,rt)
	@$(call add,THE_PROFILES,minimal)
	@$(call add,THE_PROFILES,engineering/10-design)
	@$(call add,THE_PROFILES,engineering/20-automations)

mixin/alt-engineering-live: mixin/alt-engineering use/live/ru
	@$(call add,LIVE_LISTS,$(engineering_lists))

ifeq (distro,$(IMAGE_CLASS))
distro/alt-p9-engineering-live: distro/.regular-gtk mixin/alt-engineering-live; @:

distro/alt-p9-engineering-install: distro/.regular-install-x11 \
	mixin/alt-engineering-install; @:
endif

ifeq (vm,$(IMAGE_CLASS))
vm/alt-p9-engineering: vm/.regular-desktop mixin/alt-engineering-install \
	use/oem/install; @:
endif
