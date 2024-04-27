mixin/cnc-rt: use/l10n +nm-gtk +systemd +systemd-optimal +x11 \
	mixin/regular-desktop mixin/regular-lxqt use/x11/lightdm/gtk
	@$(call set,KFLAVOURS,rt)
	@$(call add,THE_LISTS,realtime/tests)
	@$(call add,THE_LISTS,engineering/cnc)
	@$(call add,THE_LISTS,engineering/misc)
	@$(call add,THE_LISTS,kernel-headers)
	@$(call add,THE_PACKAGES,gcc-c++ liblinuxcnc-devel)
	@$(call add,THE_PACKAGES,alterator-x11)
	@$(call add,THE_PACKAGES,ethtool)
	@$(call add,THE_PACKAGES,python3-module-pip)
	@$(call add,THE_PACKAGES,openFPGALoader)

ifeq (distro,$(IMAGE_CLASS))
distro/regular-cnc-rt: distro/.regular-wm mixin/cnc-rt; @:
endif

ifeq (vm,$(IMAGE_CLASS))
vm/regular-cnc-rt: vm/systemd mixin/regular-vm-x11 mixin/vm-archdep mixin/cnc-rt; @:
endif
