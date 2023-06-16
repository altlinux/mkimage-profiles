mixin/phosh: use/x11/gdm use/x11-autologin +pipewire +nm +nm-native \
	use/services
	@$(call add,THE_PACKAGES,phosh mutter-gnome xorg-xwayland)
	@$(call add,THE_PACKAGES,bluez eg25-manager)
	@$(call add,THE_LISTS,mobile-apps)
	@$(call add,DEFAULT_SERVICES_ENABLE,bluetoothd)
	@$(call set,DEFAULT_SESSION,phosh)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,eg25-manager.service)

ifeq (vm,$(IMAGE_CLASS))
vm/.phosh: vm/systemd +systemd \
	mixin/regular-vm-base mixin/regular-x11 \
	mixin/regular-desktop mixin/phosh use/deflogin/root \
	use/deflogin/privileges use/deflogin/xgrp use/deflogin/hardware \
	use/l10n/ru_RU
	@$(call add,USERS,altlinux:271828:1:1)
	@$(call set,LOCALES,ru_RU en_US)
	@$(call set,LOCALE,ru_RU)
	@$(call set,KFLAVOURS,pine)

vm/qemu-phosh: vm/.phosh use/tty/S0 use/efi/grub +vmguest; @:
endif

ifeq (aarch64,$(ARCH))
# TODO: devicetree ($root)/boot/dtb/rockchip/rk3399-pinephone-pro.dtb
mixin/pinephone: use/x11/armsoc use/firmware use/bootloader/uboot use/tty/S2
	@$(call set,EFI_BOOTLOADER,)
	@$(call set,UBOOT_TIMEOUT,5)

ifeq (vm,$(IMAGE_CLASS))
vm/pinephone-phosh: vm/.phosh mixin/pinephone; @:
endif
endif
