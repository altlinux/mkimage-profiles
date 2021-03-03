mixin/cnc-rt: use/l10n +nm-gtk +systemd +systemd-optimal +plymouth \
	mixin/regular-lxde use/x11/lightdm/gtk
	@$(call set,KFLAVOURS,rt)
	@$(call add,THE_LISTS,realtime/tests)
	@$(call add,THE_LISTS,engineering/cnc)
	@$(call add,THE_LISTS,engineering/misc)

ifeq (distro,$(IMAGE_CLASS))
distro/cnc-rt: distro/.regular-x11 mixin/cnc-rt \
	use/live/install
	@$(call add,EFI_BOOTARGS,efi=runtime)
endif

ifeq (vm,$(IMAGE_CLASS))
vm/cnc-rt: vm/systemd mixin/regular-vm-x11 mixin/vm-archdep mixin/cnc-rt; @:
vm/cnc-rt-efi: vm/cnc-rt +efi; @:
endif
