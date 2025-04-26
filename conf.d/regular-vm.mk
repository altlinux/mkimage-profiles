ifeq (vm,$(IMAGE_CLASS))

#ifeq (,$(filter-out qcow2 qcow2c,$(IMAGE_TYPE)))
vm/regular-systemd: vm/systemd-net use/vmguest/kvm use/tty/S0 \
	use/deflogin/root use/net/networkd/resolved
	@$(call add,BASE_PACKAGES,apt-repo)
	@$(call add,BASE_PACKAGES,hasher nfs-clients git rpm-build)
	@$(call add,BASE_PACKAGES,kernel-build-tools gear)
	@$(call add,BASE_PACKAGES,systemd-settings-disable-kill-user-processes)
	@$(call add,DEFAULT_SERVICES_ENABLE,nfs-client.target)
	@$(call add,DEFAULT_SERVICES_DISABLE,consolesaver)
#endif

mixin/regular-vm-base: use/firmware use/ntp/chrony use/repo \
	use/services/lvm2-disable use/wireless
ifneq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call add,DEFAULT_SERVICES_DISABLE,multipathd)
endif
	@$(call add,DEFAULT_SERVICES_ENABLE,sshd)
	@$(call add,THE_PACKAGES,bash-completion mc update-kernel)
	@$(call add,THE_PACKAGES,vim-console)
	@$(call add,KMODULES,staging)

vm/.regular-desktop: vm/systemd +systemd +plymouth \
	mixin/regular-vm-base mixin/regular-x11 \
	mixin/regular-desktop use/oem/vnc \
	use/services/bluetooth-enable
	@$(call add,THE_PACKAGES,bluez)
	@$(call try,VM_SIZE,8589934592)

vm/.regular-gtk: vm/.regular-desktop use/x11/lightdm/gtk
	@$(call add,THE_PACKAGES,blueman)

vm/.regular-jeos-systemd: vm/systemd-net use/net/networkd/resolved \
	mixin/regular-vm-base use/deflogin/root
	@$(call add,THE_LISTS, $(call tags,base && (network || regular)))
	@$(call add,THE_PACKAGES,glibc-locales)
	@$(call add,THE_PACKAGES,systemd-settings-disable-kill-user-processes)
	@$(call add,DEFAULT_SERVICES_ENABLE,getty@tty1)
	@$(call try,VM_SIZE,4294967296)

vm/regular-jeos-systemd: vm/.regular-jeos-systemd mixin/vm-archdep; @:

vm/regular-builder: vm/regular-jeos-systemd mixin/regular-builder; @:

vm/regular-cinnamon: vm/.regular-gtk mixin/regular-cinnamon mixin/vm-archdep-x11; @:

vm/regular-gnome: vm/.regular-gtk mixin/regular-gnome mixin/vm-archdep-x11; @:

vm/regular-mate: vm/.regular-gtk mixin/mate-base mixin/vm-archdep-x11; @:
ifeq (,$(filter-out mipsel riscv64,$(ARCH)))
	@$(call add,THE_PACKAGES,mate-reduced-resource)
endif

vm/regular-xfce: vm/.regular-gtk mixin/regular-xfce mixin/vm-archdep-x11; @:
ifeq (,$(filter-out mipsel riscv64,$(ARCH)))
	@$(call add,THE_PACKAGES,xfce-reduced-resource)
endif

vm/regular-kde: vm/.regular-gtk mixin/regular-kde mixin/vm-archdep-x11; @:

vm/regular-lxqt: vm/.regular-gtk mixin/regular-lxqt mixin/vm-archdep-x11; @:

ifeq (,$(filter-out aarch64,$(ARCH)))
# Raspberry Pi 4
vm/regular-jeos-systemd-rpi: vm/.regular-jeos-systemd use/tty/AMA0 \
	use/arm-rpi4/kernel; @:

vm/regular-builder-rpi: vm/regular-jeos-systemd-rpi mixin/regular-builder; @:

vm/regular-lxqt-rpi: vm/.regular-gtk mixin/regular-lxqt use/arm-rpi4/full; @:

vm/regular-mate-rpi: vm/.regular-gtk mixin/regular-mate use/arm-rpi4/full; @:

vm/regular-xfce-rpi: vm/.regular-gtk mixin/regular-xfce use/arm-rpi4/full; @:

endif

endif
