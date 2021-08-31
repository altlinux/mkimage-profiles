mixin/cnc-rt: use/l10n +nm-gtk +systemd +systemd-optimal \
	mixin/regular-desktop mixin/regular-lxqt use/x11/lightdm/gtk
	@$(call set,KFLAVOURS,rt)
	@$(call add,THE_LISTS,realtime/tests)
	@$(call add,THE_LISTS,engineering/cnc)
	@$(call add,THE_LISTS,engineering/misc)

ifeq (distro,$(IMAGE_CLASS))
distro/regular-cnc-rt: distro/.regular-x11 mixin/cnc-rt \
	use/live/install; @:
endif

ifeq (vm,$(IMAGE_CLASS))
vm/regular-cnc-rt: vm/systemd mixin/regular-vm-x11 mixin/vm-archdep mixin/cnc-rt; @:
vm/regular-cnc-rt-efi: vm/regular-cnc-rt +efi; @:
endif
