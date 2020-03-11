mixin/cnc-rt: use/cleanup +nm-gtk
	@$(call set,KFLAVOURS,rt)
	@$(call add,THE_LISTS,realtime/tests)
	@$(call add,THE_LISTS,engineering/cnc)
	@$(call add,CLEANUP_PACKAGES,virtualbox-guest-common)
	@$(call add,CLEANUP_PACKAGES,open-vm-tools)
	@$(call add,CLEANUP_PACKAGES,xorg-drv-vboxvideo xorg-drv-qxl)
	@$(call add,CLEANUP_PACKAGES,spice-vdagent qemu-guest-agent)
	@$(call add,CLEANUP_PACKAGES,xorg-drv-vmware xorg-drv-vmmouse open-vm-tools-desktop)

ifeq (distro,$(IMAGE_CLASS))
distro/cnc-rt: distro/regular-lxde mixin/cnc-rt
	@$(call add,EFI_BOOTARGS,efi=runtime)
endif

ifeq (vm,$(IMAGE_CLASS))
vm/cnc-rt: vm/regular-lxde mixin/vm-archdep mixin/cnc-rt; @:
vm/cnc-rt-efi: vm/cnc-rt +efi; @:
endif
