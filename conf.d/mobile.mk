mixin/waydroid: ; @:
ifeq (,$(filter-out aarch64 x86_64,$(ARCH)))
	@$(call add,THE_PACKAGES,libgbinder1 waydroid)
	@$(call add,THE_KMODULES,anbox)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,waydroid-container.service)
	@$(call add,BASE_BOOTARGS,psi=1)
endif

# enables tty on the mobile device using a hotkey
mixin/ttyescape: use/services; @:
ifneq (,$(filter-out riscv64,$(ARCH)))
	@$(call add,THE_PACKAGES,hkdm ttyescape)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,hkdm)
endif

mixin/mobile-base: use/ntp/chrony use/repo use/branding/notes use/x11-autostart \
	use/deflogin/privileges use/deflogin/xgrp use/deflogin/hardware \
	use/deflogin/root use/l10n/ru_RU use/xdg-user-dirs \
	use/drm use/firmware mixin/ttyescape +plymouth +pipewire \
	use/services/bluetooth-enable
	@$(call add,THE_BRANDING,notes indexhtml)
	@$(call add,THE_LISTS,mobile/base)
	@$(call add,THE_PACKAGES,polkit-rule-mobile)
	@$(call add,THE_PACKAGES,mesa-dri-drivers)
	@$(call add,THE_PACKAGES,eg25-manager)
	@$(call add,THE_PACKAGES,udev-rules-modem-power)
	@$(call set,UBOOT_TIMEOUT,5)
	@$(call add,USERS,altlinux:271828:1:1)
	@$(call set,LOCALES,ru_RU en_US)
	@$(call set,LOCALE,ru_RU)
	@$(call add,CONTROL,fusermount:public)
	@$(call add,CONTROL,libnss-role:disabled)

mixin/phosh: use/services +nm-gtk4 +nm-native
	@$(call add,THE_LISTS,mobile/phosh)
	@$(call add,DEFAULT_SERVICES_ENABLE,phosh)
	@$(call set,DEFAULT_SESSION,phosh)
	@$(call add,THE_PACKAGES,dconf-epiphany-mobile-user-agent)
	@$(call add,THE_PACKAGES,dconf-clapper-playbin3)

ifeq (vm,$(IMAGE_CLASS))
vm/.phosh: vm/systemd mixin/mobile-base mixin/phosh +systemd \
	mixin/waydroid use/fonts/ttf/google \
	use/auto-resize
	@$(call add,THE_LISTS,mobile/apps)
	@$(call add,THE_PACKAGES,phosh-background-settings)

vm/phosh: vm/.phosh use/tty/S0 use/uboot +efi
	@$(call set,KFLAVOURS,un-def)
ifeq (aarch64,$(ARCH))
	@$(call set,VM_PARTTABLE,msdos)
	@$(call set,VM_BOOTTYPE,EFI)
endif
endif

ifeq (aarch64,$(ARCH))
mixin/pine: use/bootloader/uboot use/tty/S2
	@$(call set,EFI_BOOTLOADER,)
	@$(call set,KFLAVOURS,pine)
	@$(call add,THE_PACKAGES,alsa-ucm-conf-pinephone-pro-workaround)

ifeq (vm,$(IMAGE_CLASS))
vm/pine-phosh: vm/.phosh mixin/pine; @:

vm/mp-phosh: vm/phosh
	@$(call set,KFLAVOURS,mp)
	@$(call set,LOCALE,en_US)
endif
endif
