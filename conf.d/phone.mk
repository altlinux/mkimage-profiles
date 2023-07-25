mixin/waydroid: ; @:
ifeq (,$(filter-out aarch64 x86_64,$(ARCH)))
	@$(call add,THE_PACKAGES,libgbinder1 waydroid)
	@$(call add,THE_KMODULES,anbox)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,waydroid-container.service)
	@$(call add,BASE_BOOTARGS,psi=1)
endif

mixin/phone-base: use/ntp/chrony use/repo use/branding/notes \
	use/deflogin/privileges use/deflogin/xgrp use/deflogin/hardware \
	use/deflogin/root use/l10n/ru_RU
	@$(call add,THE_LISTS,mobile/base)
	@$(call add,USERS,altlinux:271828:1:1)
	@$(call set,LOCALES,ru_RU en_US)
	@$(call set,LOCALE,ru_RU)
	@$(call add,CONTROL,fusermount:public)
	@$(call add,CONTROL,libnss-role:disabled)

mixin/phosh: use/services +pulse +nm +nm-native
	@$(call add,THE_PACKAGES,phosh xdg-desktop-portal-gtk)
	@$(call add,THE_PACKAGES,gnome-control-center xorg-xwayland)
	@$(call add,THE_PACKAGES,gnome-terminal gedit)
	@$(call add,THE_PACKAGES,qt5-wayland qt6-wayland)
	@$(call add,THE_PACKAGES,bluez)
	@$(call add,THE_PACKAGES,tracker3 nautilus)
	@$(call add,THE_LISTS,mobile/apps)
	@$(call add,DEFAULT_SERVICES_ENABLE,phosh)
	@$(call add,DEFAULT_SERVICES_ENABLE,bluetoothd)
	@$(call set,DEFAULT_SESSION,phosh)

ifeq (vm,$(IMAGE_CLASS))
vm/.phosh: vm/systemd mixin/phone-base mixin/phosh +systemd \
	mixin/waydroid; @:

vm/phosh: vm/.phosh use/tty/S0 use/efi/grub use/uboot use/phone \
	use/firmware +x11 +plymouth +vmguest
	@$(call set,KFLAVOURS,un-def)
ifeq (aarch64,$(ARCH))
	@$(call set,VM_PARTTABLE,msdos)
	@$(call set,VM_BOOTTYPE,EFI)
endif
endif

ifeq (aarch64,$(ARCH))
# TODO: devicetree ($root)/boot/dtb/rockchip/rk3399-pinephone-pro.dtb
mixin/pinephone: use/x11/armsoc use/firmware use/bootloader/uboot use/tty/S2 \
	 use/phone
	@$(call set,EFI_BOOTLOADER,)
	@$(call set,UBOOT_TIMEOUT,5)
	@$(call set,KFLAVOURS,pine)
	@$(call add,THE_PACKAGES,eg25-manager)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,eg25-manager.service)

ifeq (vm,$(IMAGE_CLASS))
vm/pinephone-phosh: vm/.phosh mixin/pinephone +plymouth; @:
endif
endif
