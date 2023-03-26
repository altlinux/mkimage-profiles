mixin/phosh: use/x11/gdm use/x11-autologin +pipewire +nm +nm-native
	@$(call add,THE_PACKAGES,phosh mutter-gnome xorg-xwayland)
	@$(call add,THE_PACKAGES,bluez)
	@$(call add,DEFAULT_SERVICES_ENABLE,bluetoothd)
	@$(call set,DEFAULT_SESSION,phosh)

ifeq (vm,$(IMAGE_CLASS))
vm/.phosh: vm/systemd use/efi/grub +systemd \
	mixin/regular-vm-base mixin/regular-x11 \
	mixin/regular-desktop mixin/phosh use/deflogin/root \
	use/deflogin/privileges use/deflogin/xgrp use/deflogin/hardware \
	use/l10n/ru_RU
	@$(call add,USERS,altlinux:altlinux:500:500)
	@$(call set,LOCALES,ru_RU en_US)
	@$(call set,LOCALE,ru_RU)
	@$(call set,KFLAVOURS,un-def)

vm/qemu-phosh: vm/.phosh use/tty/S0 +vmguest; @:
endif

ifeq (aarch64,$(ARCH))
# TODO: devicetree ($root)/boot/dtb/rockchip/rk3399-pinephone-pro.dtb
mixin/pinephone: use/x11/armsoc use/firmware use/uboot use/tty/S2; @:

ifeq (vm,$(IMAGE_CLASS))
vm/pinephone-phosh: vm/.phosh mixin/pinephone; @:
endif
endif
