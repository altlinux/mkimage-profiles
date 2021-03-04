ifeq (vm,$(IMAGE_CLASS))

mixin/vm-archdep:: ; @:

ifeq (,$(filter-out i586 x86_64 armh aarch64,$(ARCH)))
mixin/vm-archdep::
	@$(call set,KFLAVOURS,std-def un-def)
endif

ifeq (,$(filter-out armh aarch64,$(ARCH)))
mixin/vm-archdep:: use/bootloader/uboot use/no-sleep; @:
endif

ifeq (,$(filter-out mipsel,$(ARCH)))
mixin/vm-archdep:: use/tty/S0
	@$(call set,KFLAVOURS,un-malta)
endif

ifeq (,$(filter-out riscv64,$(ARCH)))
mixin/vm-archdep:: use/bootloader/uboot use/tty/S0
	@$(call set,KFLAVOURS,un-def)
endif

mixin/regular-vm-base: use/firmware use/ntp/chrony use/repo \
	use/services/lvm2-disable
ifneq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call add,DEFAULT_SERVICES_DISABLE,multipathd)
endif
	@$(call add,THE_PACKAGES,bash-completion mc update-kernel)
	@$(call add,THE_PACKAGES,vim-console)
	@$(call add,KMODULES,staging)

mixin/regular-vm-jeos: mixin/regular-vm-base use/deflogin/root
	@$(call add,DEFAULT_SERVICES_ENABLE,getty@tty1)

mixin/regular-vm-x11:: mixin/regular-vm-base mixin/regular-x11 \
	mixin/regular-desktop use/oem +wireless; @:

ifeq (,$(filter-out riscv64,$(ARCH)))
mixin/regular-vm-x11:: use/oem/vnc; @:
endif

vm/.regular-desktop:: vm/systemd mixin/regular-vm-x11 +systemd +systemd-optimal \
	+plymouth; @:

ifeq (,$(filter-out armh aarch64,$(ARCH)))
vm/.regular-desktop::
	@$(call add,THE_PACKAGES,xorg-96dpi)
	@$(call add,THE_LISTS,remote-access)
endif

vm/.regular-desktop-sysv: vm/bare mixin/regular-vm-x11 use/x11/gdm2.20 \
	use/init/sysv/polkit +power; @:

vm/.regular-gtk: vm/.regular-desktop use/x11/lightdm/gtk
	@$(call add,THE_PACKAGES,blueberry)

vm/.regular-qt: vm/.regular-desktop use/x11/sddm; @:

vm/regular-jeos-systemd: vm/systemd-net \
	mixin/regular-vm-jeos mixin/vm-archdep
	@$(call add,THE_PACKAGES,glibc-locales)

vm/regular-jeos-sysv: vm/net mixin/regular-vm-jeos mixin/vm-archdep +power; @:

vm/regular-builder: vm/regular-jeos-sysv mixin/regular-builder
	@$(call set,VM_SIZE,10737418240)

vm/regular-icewm-sysv: vm/.regular-desktop-sysv mixin/regular-icewm \
	mixin/vm-archdep; @:

vm/regular-cinnamon: vm/.regular-gtk mixin/regular-cinnamon mixin/vm-archdep; @:

vm/regular-gnome3: vm/.regular-gtk mixin/regular-gnome3 mixin/vm-archdep; @:

vm/regular-lxde: vm/.regular-gtk mixin/regular-lxde mixin/vm-archdep; @:

vm/regular-mate: vm/.regular-gtk mixin/mate-base mixin/vm-archdep
	@$(call add,THE_PACKAGES,mate-reduced-resource)

vm/regular-xfce: vm/.regular-gtk mixin/regular-xfce mixin/vm-archdep
	@$(call add,THE_PACKAGES,xfce-reduced-resource)
ifeq (,$(filter-out armh aarch64,$(ARCH)))
	@$(call set,KFLAVOURS,mp)
endif

vm/regular-kde5: vm/.regular-gtk mixin/regular-kde5 mixin/vm-archdep; @:

vm/regular-lxqt: vm/.regular-gtk mixin/regular-lxqt mixin/vm-archdep; @:

ifeq (,$(filter-out aarch64 armh,$(ARCH)))
# Raspberry Pi 4
vm/regular-jeos-systemd-rpi: vm/systemd-net mixin/regular-vm-jeos use/tty/AMA0 \
	use/arm-rpi4/kernel; @:

vm/regular-jeos-sysv-rpi: vm/net mixin/regular-vm-jeos use/tty/AMA0 \
	use/arm-rpi4/kernel +power; @:

vm/regular-builder-rpi: vm/regular-jeos-systemd-rpi mixin/regular-builder; @:

vm/regular-lxde-rpi: vm/.regular-gtk mixin/regular-lxde use/arm-rpi4/full; @:

vm/regular-lxqt-rpi: vm/.regular-gtk mixin/regular-lxqt use/arm-rpi4/full; @:

vm/regular-mate-rpi: vm/.regular-gtk mixin/regular-mate use/arm-rpi4/full; @:

vm/regular-xfce-rpi: vm/.regular-gtk mixin/regular-xfce use/arm-rpi4/full; @:

ifeq (,$(filter-out aarch64,$(ARCH)))
# Nvidia Tegra (Jetson Nano only)
vm/regular-cinnamon-tegra: vm/.regular-gtk mixin/regular-cinnamon \
	use/x11/lightdm/slick use/aarch64-tegra; @:

vm/regular-kde5-tegra: vm/.regular-gtk mixin/regular-kde5 use/aarch64-tegra
	@$(call add,THE_PACKAGES,kde5-ksplash-disabled)

vm/regular-lxqt-tegra: vm/.regular-gtk mixin/regular-lxqt use/aarch64-tegra; @:

vm/regular-mate-tegra: vm/.regular-gtk mixin/regular-mate use/aarch64-tegra; @:

vm/regular-xfce-tegra: vm/.regular-gtk mixin/regular-xfce use/aarch64-tegra; @:

# DBM BE-M1000
vm/regular-xfce-dbm: vm/.regular-gtk mixin/regular-xfce use/aarch64-dbm; @:

vm/regular-gnome3-dbm: vm/.regular-gtk mixin/regular-gnome3 use/aarch64-dbm; @:
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
endif

ifeq (,$(filter-out mipsel,$(ARCH)))
# Tavolga
vm/regular-jeos-systemd-tavolga: vm/systemd-net mixin/regular-vm-jeos \
	use/mipsel-mitx; @:

vm/regular-jeos-sysv-tavolga: vm/net mixin/regular-vm-jeos \
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
vm/regular-jeos-systemd-bfk3: vm/systemd-net mixin/regular-vm-jeos \
	use/mipsel-bfk3; @:

vm/regular-jeos-sysv-bfk3: vm/net mixin/regular-vm-jeos \
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
