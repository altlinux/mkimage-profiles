mixin/cnc-rt: +nm-gtk
	@$(call set,KFLAVOURS,rt)
	@$(call add,THE_LISTS,realtime/tests)
	@$(call add,THE_LISTS,engineering/cnc)

ifeq (distro,$(IMAGE_CLASS))
distro/cnc-rt: distro/regular-lxde mixin/cnc-rt
	@$(call add,EFI_BOOTARGS,efi=runtime)
endif

ifeq (vm,$(IMAGE_CLASS))
vm/cnc-rt: vm/regular-lxde mixin/vm-archdep mixin/cnc-rt; @:
vm/cnc-rt-efi: vm/cnc-rt +efi; @:
endif
