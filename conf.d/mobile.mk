# enables tty on the mobile device using a hotkey
mixin/ttyescape: use/services; @:
ifneq (,$(filter-out riscv64,$(ARCH)))
	@$(call add,THE_PACKAGES,hkdm ttyescape)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,hkdm)
endif

mixin/mobile-base:: use/ntp/chrony use/repo use/branding/notes use/x11-autostart \
	use/deflogin/privileges use/deflogin/xgrp use/deflogin/hardware \
	use/deflogin/root use/l10n/ru_RU use/xdg-user-dirs \
	use/drm use/firmware mixin/ttyescape +plymouth +pipewire \
	use/services/bluetooth-enable use/luks/touchscreen
ifeq (sisyphus,$(BRANCH))
	@$(call set,BRANDING,alt-mobile-sisyphus)
else
	@$(call set,BRANDING,alt-mobile)
endif
	@$(call add,THE_BRANDING,graphics notes indexhtml)
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
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,waked.service)

mixin/phosh: use/services +nm-gtk4 +nm-native
	@$(call add,THE_BRANDING,phosh-settings)
	@$(call add,THE_LISTS,mobile/phosh)
	@$(call add,DEFAULT_SERVICES_ENABLE,phosh)
	@$(call set,DEFAULT_SESSION,phosh)
	@$(call add,THE_PACKAGES,dconf-epiphany-mobile-user-agent)

ifneq (sisyphus,$(BRANCH))
mixin/mobile-base::
	@$(call add,THE_LISTS,mobile/AD)
endif

ifeq (vm,$(IMAGE_CLASS))
vm/.phosh: vm/systemd mixin/mobile-base mixin/phosh +systemd \
	mixin/waydroid use/fonts/ttf/google \
	use/auto-resize
	@$(call add,THE_LISTS,mobile/apps)

vm/alt-mobile-phosh-un-def: vm/.phosh mixin/uboot-extlinux-efi use/tty/S0
	@$(call set,KFLAVOURS,un-def)

vm/alt-mobile-phosh-un-def-ad: vm/alt-mobile-phosh-un-def mixin/mobile-ad; @:

ifeq (aarch64,$(ARCH))
mixin/mobile-pine: mixin/uboot-extlinux use/tty/S2
	@$(call set,KFLAVOURS,pine)
	@$(call add,THE_PACKAGES,alsa-ucm-conf-pinephone-pro-workaround)

mixin/mobile-mp: mixin/uboot-extlinux use/tty/S0
	@$(call set,KFLAVOURS,mp)

mixin/mobile-lt11i: mixin/uboot-extlinux use/tty/S0
	@$(call set,KFLAVOURS,lt11i)
	@$(call add,THE_PACKAGES,lt11i-bluetooth)
	@$(call add,THE_PACKAGES,firmware-lt11i)
	@$(call add,THE_PACKAGES,blacklist-lt11i-camera)

mixin/mobile-nxp: mixin/uboot-extlinux use/tty/S0
	@$(call set,KFLAVOURS,nxp)

mixin/mobile-rocknix: mixin/uboot-extlinux use/tty/S0
	@$(call set,KFLAVOURS,rocknix)
	@$(call add,THE_PACKAGES,u-boot-rockchip)
	@$(call add,THE_PACKAGES,rg552-hw-control)
	@$(call add,THE_PACKAGES,udev-rules-goodix-touchpad)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,rg552-fancontrol.service)
	@$(call add,DEFAULT_SYSTEMD_SERVICES_ENABLE,rg552-wifi.service)

vm/alt-mobile-phosh-pine: vm/.phosh mixin/mobile-pine; @:
vm/alt-mobile-phosh-mp: vm/.phosh mixin/mobile-mp; @:
vm/alt-mobile-phosh-lt11i: vm/.phosh mixin/mobile-lt11i; @:
vm/alt-mobile-phosh-nxp: vm/.phosh mixin/mobile-nxp; @:
vm/alt-mobile-phosh-rocknix: vm/.phosh mixin/mobile-rocknix; @:
endif
endif
