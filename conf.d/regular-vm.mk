ifeq (vm,$(IMAGE_CLASS))

ifeq (,$(filter-out armh aarch64,$(ARCH)))
mixin/vm-archdep: use/bootloader/uboot
	@$(call set,KFLAVOURS,mp lts)
else
ifeq (,$(filter-out mipsel,$(ARCH)))
mixin/vm-archdep: use/tty/S0
	@$(call set,KFLAVOURS,un-malta)
else
mixin/vm-archdep: ; @:
endif
endif


mixin/regular-vm-base: use/firmware use/ntp/chrony use/repo
ifneq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call add,DEFAULT_SERVICES_DISABLE,multipathd)
endif
	@$(call add,THE_PACKAGES,vim-console)
	@$(call add,THE_LISTS,$(call tags,base regular))

mixin/regular-vm-jeos: mixin/regular-vm-base use/deflogin/root; @:

mixin/regular-vm-x11: mixin/regular-vm-base mixin/regular-x11 \
	mixin/regular-desktop use/browser/firefox/esr use/oem
	@$(call add,THE_PACKAGES,mpv)
ifeq (,$(filter-out armh aarch64,$(ARCH)))
	@$(call add,THE_PACKAGES,xorg-96dpi)
	@$(call add,THE_LISTS,remote-access)
endif

vm/.regular-desktop: vm/systemd mixin/regular-vm-x11 +systemd-optimal; @:

vm/.regular-desktop-sysv: vm/bare mixin/regular-vm-x11 use/x11/gdm2.20 \
	+elogind +power; @:

vm/.regular-gtk: vm/.regular-desktop use/x11/lightdm/gtk
	@$(call add,THE_PACKAGES,blueberry)

vm/.regular-qt: vm/.regular-desktop use/x11/sddm; @:

vm/regular-jeos-systemd: vm/systemd-net \
	mixin/regular-vm-jeos mixin/vm-archdep; @:

vm/regular-jeos-sysv: vm/net mixin/regular-vm-jeos mixin/vm-archdep +power; @:

vm/regular-builder: vm/regular-jeos-sysv mixin/regular-builder; @:

vm/regular-icewm: vm/.regular-desktop-sysv mixin/regular-icewm \
	mixin/vm-archdep; @:

vm/regular-cinnamon: vm/.regular-gtk mixin/regular-cinnamon mixin/vm-archdep \
	use/x11/lightdm/slick; @:

vm/regular-lxde: vm/.regular-gtk mixin/regular-lxde mixin/vm-archdep; @:

vm/regular-mate: vm/.regular-gtk mixin/mate-base mixin/vm-archdep
	@$(call add,THE_PACKAGES,mate-reduced-resource)

vm/regular-xfce: vm/.regular-gtk mixin/regular-xfce mixin/vm-archdep; @:

vm/regular-kde5: vm/.regular-gtk mixin/regular-kde5 mixin/vm-archdep; @:

vm/regular-lxqt: vm/.regular-gtk mixin/regular-lxqt mixin/vm-archdep; @:

ifeq (,$(filter-out aarch64,$(ARCH)))
# Nvidia Tegra (Jetson Nano only)
vm/regular-cinnamon-tegra: vm/.regular-gtk mixin/regular-cinnamon \
	use/x11/lightdm/slick use/aarch64-tegra; @:

vm/regular-kde5-tegra: vm/.regular-gtk mixin/regular-kde5 use/aarch64-tegra; @:

vm/regular-lxqt-tegra: vm/.regular-gtk mixin/regular-lxqt use/aarch64-tegra; @:

vm/regular-mate-tegra: vm/.regular-gtk mixin/regular-mate use/aarch64-tegra; @:

vm/regular-xfce-tegra: vm/.regular-gtk mixin/regular-xfce use/aarch64-tegra; @:
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
	use/armh-mcom02/x11; @:

# ELVIS mcom02 (propietary videodriver)
vm/regular-lxde-mcom02-mali: vm/.regular-gtk mixin/regular-lxde \
	use/armh-mcom02/mali; @:

vm/regular-lxqt-mcom02-mali: vm/.regular-gtk mixin/regular-lxqt \
	use/armh-mcom02/mali; @:

vm/regular-mate-mcom02-mali: vm/.regular-gtk mixin/mate-base \
	use/armh-mcom02/mali; @:

vm/regular-xfce-mcom02-mali: vm/.regular-gtk mixin/regular-xfce \
	use/armh-mcom02/mali; @:
endif

ifeq (,$(filter-out mipsel,$(ARCH)))
# Tavolga
vm/tavolga-regular-jeos-systemd: vm/systemd-net mixin/regular-vm-jeos \
	use/mipsel-mitx; @:

vm/tavolga-regular-jeos-sysv: vm/net mixin/regular-vm-jeos \
	use/mipsel-mitx +power; @:

vm/tavolga-regular-builder: vm/tavolga-regular-jeos-sysv \
	mixin/regular-builder; @:

vm/tavolga-regular-icewm: vm/.regular-desktop-sysv mixin/regular-icewm \
	use/mipsel-mitx/x11; @:

vm/tavolga-regular-lxde: vm/.regular-gtk mixin/regular-lxde \
	use/mipsel-mitx/x11; @:

vm/tavolga-regular-lxqt: vm/.regular-gtk mixin/regular-lxqt \
	use/mipsel-mitx/x11; @:

vm/tavolga-regular-mate: vm/.regular-gtk mixin/regular-mate \
	use/mipsel-mitx/x11
	@$(call add,THE_PACKAGES,mate-reduced-resource)

vm/tavolga-regular-xfce: vm/.regular-gtk mixin/regular-xfce \
	use/mipsel-mitx/x11
	@$(call add,THE_PACKAGES,xfce-reduced-resource)

# bfk3
vm/bfk3-regular-jeos-systemd: vm/systemd-net mixin/regular-vm-jeos \
	use/mipsel-bfk3; @:

vm/bfk3-regular-jeos-sysv: vm/net mixin/regular-vm-jeos \
	use/mipsel-bfk3 +power; @:

vm/bfk3-regular-builder: vm/bfk3-regular-jeos-sysv \
	mixin/regular-builder; @:

vm/bfk3-regular-icewm: vm/.regular-desktop-sysv mixin/regular-icewm \
	use/mipsel-bfk3/x11; @:

vm/bfk3-regular-lxde: vm/.regular-gtk mixin/regular-lxde \
	use/mipsel-bfk3/x11; @:

vm/bfk3-regular-lxqt: vm/.regular-gtk mixin/regular-lxqt \
	use/mipsel-bfk3/x11; @:

vm/bfk3-regular-mate: vm/.regular-gtk mixin/regular-mate \
	use/mipsel-bfk3/x11
	@$(call add,THE_PACKAGES,mate-reduced-resource)

vm/bfk3-regular-xfce: vm/.regular-gtk mixin/regular-xfce \
	use/mipsel-bfk3/x11
	@$(call add,THE_PACKAGES,xfce-reduced-resource)
endif

endif
