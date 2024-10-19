# virtual machines
ifeq (vm,$(IMAGE_CLASS))

vm/mate-a11y: vm/systemd mixin/regular-vm-base mixin/regular-x11 \
	mixin/regular-desktop mixin/mate-base mixin/vm-archdep-x11 \
	use/deflogin/privileges use/deflogin/xgrp use/deflogin/hardware \
	use/deflogin/root use/x11-autologin use/l10n/ru_RU use/x11/lightdm/gtk \
	+systemd +systemd-optimal +vmguest \
	use/services/bluetooth-enable
	@$(call add,USERS,altlinux:altlinux:1:1)
	@$(call add,THE_PACKAGES,bluez blueman)
	@$(call add,THE_LISTS,a11y)
	@$(call add,THE_PACKAGES,theme-mate-windows)

endif
