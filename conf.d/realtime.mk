mixin/cnc-rt: use/l10n +nm-gtk +systemd +systemd-optimal \
	mixin/regular-desktop mixin/regular-lxqt use/x11/lightdm/gtk
	@$(call set,KFLAVOURS,rt)
	@$(call add,THE_LISTS,realtime/tests)
	@$(call add,THE_LISTS,engineering/cnc)
	@$(call add,THE_LISTS,engineering/misc)
	@$(call add,THE_LISTS,kernel-headers)
	@$(call add,THE_PACKAGES,gcc-c++ liblinuxcnc-devel)

ifeq (distro,$(IMAGE_CLASS))
distro/regular-cnc-rt: distro/.regular-wm mixin/cnc-rt; @:
endif

ifeq (vm,$(IMAGE_CLASS))
vm/regular-cnc-rt: vm/systemd mixin/regular-vm-x11 mixin/vm-archdep mixin/cnc-rt; @:
endif
