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

mixin/vm-archdep:: use/auto-resize; @:

ifeq (,$(filter-out i586 x86_64 aarch64,$(ARCH)))
mixin/vm-archdep::
	@$(call set,KFLAVOURS,std-def un-def)
endif

ifeq (,$(filter-out armh,$(ARCH)))
mixin/vm-archdep::
	@$(call set,KFLAVOURS,un-def mp)
endif


ifeq (,$(filter-out armh aarch64,$(ARCH)))
mixin/vm-archdep:: use/bootloader/uboot use/no-sleep use/arm-rpi4; @:
endif

ifeq (,$(filter-out mipsel,$(ARCH)))
mixin/vm-archdep:: use/tty/S0
	@$(call set,KFLAVOURS,un-malta)
endif

ifeq (,$(filter-out riscv64,$(ARCH)))
mixin/vm-archdep:: use/bootloader/uboot
	@$(call set,KFLAVOURS,un-def)
endif

mixin/vm-archdep-x11: mixin/vm-archdep +vmguest; @:

mixin/regular-vm-base: use/firmware use/ntp/chrony use/repo \
	use/services/lvm2-disable use/wireless
ifneq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call add,DEFAULT_SERVICES_DISABLE,multipathd)
endif
	@$(call add,DEFAULT_SERVICES_ENABLE,sshd)
	@$(call add,THE_PACKAGES,bash-completion mc update-kernel)
	@$(call add,THE_PACKAGES,vim-console)
	@$(call add,KMODULES,staging)

mixin/regular-vm-jeos: mixin/regular-vm-base use/deflogin/root \
	use/net/etcnet use/net/dhcp
	@$(call add,THE_PACKAGES,livecd-net-eth)
	@$(call add,THE_LISTS, $(call tags,base && (network || regular)))
	@$(call add,DEFAULT_SERVICES_ENABLE,getty@tty1 livecd-net-eth)

mixin/regular-vm-x11:: mixin/regular-vm-base mixin/regular-x11 \
	mixin/regular-desktop use/oem/vnc; @:

vm/.regular-desktop: vm/systemd mixin/regular-vm-x11 \
	+systemd +systemd-optimal +plymouth
	@$(call add,THE_PACKAGES,bluez)
	@$(call add,THE_PACKAGES,glmark2 glmark2-es2)
	@$(call add,DEFAULT_SERVICES_ENABLE,bluetoothd)
	@$(call try,VM_SIZE,6442450944)

vm/.regular-desktop-sysv: vm/bare mixin/regular-vm-x11 use/x11/gdm2.20 \
	use/init/sysv/polkit +power; @:

vm/.regular-gtk: vm/.regular-desktop use/x11/lightdm/gtk
	@$(call add,THE_PACKAGES,blueman)

vm/.regular-qt: vm/.regular-desktop use/x11/sddm; @:

vm/regular-jeos-systemd: vm/systemd \
	mixin/regular-vm-jeos mixin/vm-archdep
	@$(call add,THE_PACKAGES,glibc-locales)
	@$(call add,THE_PACKAGES,systemd-settings-disable-kill-user-processes)
	@$(call try,VM_SIZE,3221225472)

vm/regular-jeos-sysv: vm/bare mixin/regular-vm-jeos mixin/vm-archdep +power; @:

vm/regular-builder: vm/regular-jeos-systemd mixin/regular-builder +nm
	@$(call add,THE_PACKAGES,NetworkManager-tui)

vm/regular-icewm-sysv: vm/.regular-desktop-sysv mixin/regular-icewm \
	mixin/vm-archdep-x11; @:

vm/regular-cinnamon: vm/.regular-gtk mixin/regular-cinnamon mixin/vm-archdep-x11; @:

vm/regular-deepin: vm/.regular-gtk mixin/regular-deepin mixin/vm-archdep-x11; @:

vm/regular-gnome3: vm/.regular-gtk mixin/regular-gnome3 mixin/vm-archdep-x11
	@$(call set,VM_SIZE,8589934592)

vm/regular-lxde: vm/.regular-gtk mixin/regular-lxde mixin/vm-archdep-x11; @:

vm/regular-mate: vm/.regular-gtk mixin/mate-base mixin/vm-archdep-x11; @:
ifeq (,$(filter-out mipsel riscv64,$(ARCH)))
	@$(call add,THE_PACKAGES,mate-reduced-resource)
endif

vm/regular-xfce: vm/.regular-gtk mixin/regular-xfce mixin/vm-archdep-x11; @:
ifeq (,$(filter-out mipsel riscv64,$(ARCH)))
	@$(call add,THE_PACKAGES,xfce-reduced-resource)
endif

vm/regular-kde5: vm/.regular-gtk mixin/regular-kde5 mixin/vm-archdep-x11
	@$(call set,VM_SIZE,7516192768)

vm/regular-lxqt: vm/.regular-gtk mixin/regular-lxqt mixin/vm-archdep-x11; @:

ifeq (,$(filter-out aarch64,$(ARCH)))
# Raspberry Pi 4
vm/regular-jeos-systemd-rpi: vm/systemd mixin/regular-vm-jeos use/tty/AMA0 \
	use/arm-rpi4/kernel; @:

vm/regular-jeos-sysv-rpi: vm/bare mixin/regular-vm-jeos use/tty/AMA0 \
	use/arm-rpi4/kernel +power; @:

vm/regular-builder-rpi: vm/regular-jeos-systemd-rpi mixin/regular-builder; @:

vm/regular-deepin-rpi: vm/.regular-gtk mixin/regular-deepin use/arm-rpi4/full; @:

vm/regular-lxde-rpi: vm/.regular-gtk mixin/regular-lxde use/arm-rpi4/full; @:

vm/regular-lxqt-rpi: vm/.regular-gtk mixin/regular-lxqt use/arm-rpi4/full; @:

vm/regular-mate-rpi: vm/.regular-gtk mixin/regular-mate use/arm-rpi4/full; @:

vm/regular-xfce-rpi: vm/.regular-gtk mixin/regular-xfce use/arm-rpi4/full; @:

endif

ifeq (,$(filter-out armh,$(ARCH)))
# ELVIS mcom02 (free videodriver)
vm/regular-lxde-mcom02: vm/.regular-gtk mixin/regular-lxde \
	use/armh-mcom02/x11; @:

vm/regular-lxqt-mcom02: vm/.regular-gtk mixin/regular-lxqt \
	use/armh-mcom02/x11; @:

vm/regular-mate-mcom02: vm/.regular-gtk mixin/regular-mate \
	use/armh-mcom02/x11
	@$(call add,THE_PACKAGES,mate-reduced-resource)

vm/regular-xfce-mcom02: vm/.regular-gtk mixin/regular-xfce \
	use/armh-mcom02/x11
	@$(call add,THE_PACKAGES,xfce-reduced-resource)

# ELVIS mcom02 (propietary videodriver)
vm/regular-lxde-mcom02-mali: vm/.regular-gtk mixin/regular-lxde \
	use/armh-mcom02/mali; @:

vm/regular-lxqt-mcom02-mali: vm/.regular-gtk mixin/regular-lxqt \
	use/armh-mcom02/mali; @:

vm/regular-mate-mcom02-mali: vm/.regular-gtk mixin/mate-base \
	use/armh-mcom02/mali
	@$(call add,THE_PACKAGES,mate-reduced-resource)

vm/regular-xfce-mcom02-mali: vm/.regular-gtk mixin/regular-xfce \
	use/armh-mcom02/mali
	@$(call add,THE_PACKAGES,xfce-reduced-resource)
endif

ifeq (,$(filter-out mipsel,$(ARCH)))
# Tavolga
vm/regular-jeos-systemd-tavolga: vm/systemd mixin/regular-vm-jeos \
	use/mipsel-mitx; @:

vm/regular-jeos-sysv-tavolga: vm/bare mixin/regular-vm-jeos \
	use/mipsel-mitx +power; @:

vm/regular-builder-tavolga: vm/regular-jeos-sysv-tavolga \
	mixin/regular-builder; @:

vm/regular-icewm-sysv-tavolga: vm/.regular-desktop-sysv mixin/regular-icewm \
	use/mipsel-mitx/x11; @:

vm/regular-lxde-tavolga: vm/.regular-gtk mixin/regular-lxde \
	use/mipsel-mitx/x11; @:

vm/regular-lxqt-tavolga: vm/.regular-gtk mixin/regular-lxqt \
	use/mipsel-mitx/x11; @:

vm/regular-mate-tavolga: vm/.regular-gtk mixin/regular-mate \
	use/mipsel-mitx/x11
	@$(call add,THE_PACKAGES,mate-reduced-resource)

vm/regular-xfce-tavolga: vm/.regular-gtk mixin/regular-xfce \
	use/mipsel-mitx/x11
	@$(call add,THE_PACKAGES,xfce-reduced-resource)

# bfk3
vm/regular-jeos-systemd-bfk3: vm/systemd mixin/regular-vm-jeos \
	use/mipsel-bfk3; @:

vm/regular-jeos-sysv-bfk3: vm/bare mixin/regular-vm-jeos \
	use/mipsel-bfk3 +power; @:

vm/regular-builder-bfk3: vm/regular-jeos-sysv-bfk3 \
	mixin/regular-builder; @:

vm/regular-icewm-sysv-bfk3: vm/.regular-desktop-sysv mixin/regular-icewm \
	use/mipsel-bfk3/x11; @:

vm/regular-lxde-bfk3: vm/.regular-gtk mixin/regular-lxde \
	use/mipsel-bfk3/x11; @:

vm/regular-lxqt-bfk3: vm/.regular-gtk mixin/regular-lxqt \
	use/mipsel-bfk3/x11; @:

vm/regular-mate-bfk3: vm/.regular-gtk mixin/regular-mate \
	use/mipsel-bfk3/x11
	@$(call add,THE_PACKAGES,mate-reduced-resource)

vm/regular-xfce-bfk3: vm/.regular-gtk mixin/regular-xfce \
	use/mipsel-bfk3/x11
	@$(call add,THE_PACKAGES,xfce-reduced-resource)
endif

endif
