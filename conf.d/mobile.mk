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
	use/services/bluetooth-enable use/luks/touchscreen \
	use/wireless
ifeq (sisyphus,$(BRANCH))
	@$(call set,BRANDING,alt-mobile-sisyphus)
else
	@$(call set,BRANDING,alt-mobile)
endif
	@$(call try,CAMERA,snapshot)
	@$(call add,THE_PACKAGES,$$(CAMERA))
	@$(call add,THE_BRANDING,graphics notes indexhtml)
	@$(call add,THE_LISTS,mobile/base)
	@$(call add,THE_LISTS,mobile/apps)
	@$(call add,THE_LISTS,mobile/AD)
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
	@$(call add,CONTROL,passwdqc-match:no_check)
	@$(call add,CONTROL,passwdqc-min:allow_pincode)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,waked.service)

ifeq (sisyphus,$(BRANCH))
mixin/mobile-def: mixin/uboot-extlinux-efi use/tty/S0; @:
else
mixin/mobile-def: mixin/uboot-extlinux-efi; @:
endif

mixin/phosh: use/services +nm-gtk4 +nm-native
	@$(call add,THE_BRANDING,phosh-settings)
	@$(call add,THE_LISTS,mobile/phosh)
	@$(call add,THE_LISTS,mobile/gnome-apps)
	@$(call add,DEFAULT_SERVICES_ENABLE,phosh)
	@$(call set,DEFAULT_SESSION,phosh)
ifeq (sisyphus,$(BRANCH))
	@$(call add,THE_PACKAGES,gnome-maps)
endif
ifeq (x86_64,$(ARCH))
	@$(call add,THE_PACKAGES,udev-rules-MIG-goodix-touchpad)
endif

ifeq (vm,$(IMAGE_CLASS))
vm/.phosh: vm/systemd mixin/mobile-base mixin/phosh +systemd \
	mixin/waydroid use/fonts/ttf/google \
	use/auto-resize; @:

vm/alt-mobile-phosh-def: vm/.phosh mixin/mobile-def; @:

ifeq (aarch64,$(ARCH))
ifeq (sisyphus,$(BRANCH))
mixin/mobile-pine: mixin/uboot-extlinux use/tty/S2
else
mixin/mobile-pine: mixin/uboot-extlinux
endif
	@$(call set,KFLAVOURS,pine)
	@$(call set,CAMERA,megapixels)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,eg25-manager.service)
	@$(call add,THE_PACKAGES,alsa-ucm-conf-pinephone-pro-workaround)
	@$(call add,THE_PACKAGES,udev-rules-goodix-touchpad)

ifeq (sisyphus,$(BRANCH))
mixin/mobile-lt11i: mixin/uboot-extlinux use/tty/S0
else
mixin/mobile-lt11i: mixin/uboot-extlinux
endif
	@$(call set,KFLAVOURS,lt11i)
	@$(call add,THE_PACKAGES,lt11i-bluetooth)
	@$(call add,THE_PACKAGES,firmware-lt11i)
	@$(call add,THE_PACKAGES,blacklist-lt11i-camera)

ifeq (sisyphus,$(BRANCH))
mixin/mobile-rocknix: mixin/uboot-extlinux use/tty/S0
else
mixin/mobile-rocknix: mixin/uboot-extlinux
endif
	@$(call set,KFLAVOURS,rocknix)
	@$(call add,THE_PACKAGES,u-boot-rockchip)
	@$(call add,THE_PACKAGES,rg552-hw-control)
	@$(call add,THE_PACKAGES,rg552-fancontrol-quick-setting)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,rg552-fancontrol.service)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,rg552-wifi.service)

vm/alt-mobile-phosh-pine: vm/.phosh mixin/mobile-pine; @:
vm/alt-mobile-phosh-lt11i: vm/.phosh mixin/mobile-lt11i; @:
vm/alt-mobile-phosh-rocknix: vm/.phosh mixin/mobile-rocknix; @:
endif
endif
