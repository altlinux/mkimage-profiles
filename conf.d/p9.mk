# p9 base kits

mixin/p9::
	@$(call set,BRANDING,alt-starterkit)
	@$(call set,IMAGE_FLAVOUR,$(subst alt-p9-,,$(IMAGE_NAME)))
	@$(call set,META_VOL_ID,ALT p9 $$(IMAGE_FLAVOUR)/$(ARCH))

ifneq (,$(filter-out aarch64,$(ARCH)))
mixin/p9:: use/browser/firefox/esr
endif

ifeq (distro,$(IMAGE_CLASS))

distro/alt-p9-cinnamon distro/alt-p9-enlightenment \
	distro/alt-p9-gnome3 distro/alt-p9-gnustep-sysv \
	distro/alt-p9-icewm-sysv distro/alt-p9-kde5 \
	distro/alt-p9-lxde distro/alt-p9-lxqt \
	distro/alt-p9-mate distro/alt-p9-rescue \
	distro/alt-p9-wmaker-sysv distro/alt-p9-xfce \
	distro/alt-p9-xfce-sysv distro/alt-p9-xfce-sysv-install: \
	distro/alt-p9-%: distro/regular-% mixin/p9; @:

distro/alt-p9-jeos-sysv distro/alt-p9-jeos-ovz distro/alt-p9-jeos-systemd \
	distro/alt-p9-server-systemd distro/alt-p9-server-sysv \
	distro/alt-p9-server-ovz \
	distro/alt-p9-server-hyperv distro/alt-p9-server-samba4 \
	distro/alt-p9-server-pve distro/alt-p9-server-lxd: \
	distro/alt-p9-%: distro/regular-% mixin/p9; @:

distro/alt-p9-builder: distro/regular-builder mixin/p9; @:

ifeq (,$(filter-out x86_64,$(ARCH)))
distro/alt-p9-cnc-rt: distro/cnc-rt mixin/p9; @:
endif
endif

ifeq (ve,$(IMAGE_CLASS))
ve/alt-p9-ovz-generic: ve/generic mixin/p9; @:

ve/docker-p9: ve/docker; @:
	@$(call set,BRANDING,alt-starterkit)
endif

ifeq (vm,$(IMAGE_CLASS))
vm/alt-p9-vm-net: vm/net mixin/p9; @:
vm/alt-p9-cloud: vm/cloud-systemd mixin/p9; @:
vm/alt-p9-opennebula: vm/opennebula-systemd mixin/p9; @:

# universal builds rootfs and image for all platforms
vm/alt-p9-jeos-systemd vm/alt-p9-jeos-sysv vm/alt-p9-builder \
	vm/alt-p9-cinnamon vm/alt-p9-gnome3 vm/alt-p9-kde5 \
	vm/alt-p9-icewm-sysv vm/alt-p9-lxde \
	vm/alt-p9-lxqt vm/alt-p9-mate \
	vm/alt-p9-xfce: \
	vm/alt-p9-%: vm/regular-% mixin/p9; @:

ifeq (,$(filter-out aarch64 armh,$(ARCH)))
vm/alt-p9-jeos-systemd-rpi vm/alt-p9-jeos-sysv-rpi \
	vm/alt-p9-builder-rpi \
	vm/alt-p9-lxde-rpi vm/alt-p9-lxqt-rpi \
	vm/alt-p9-mate-rpi vm/alt-p9-xfce-rpi: \
	vm/alt-p9-%-rpi: vm/regular-%-rpi mixin/p9; @:

ifeq (,$(filter-out aarch64,$(ARCH)))
vm/alt-p9-cinnamon-tegra vm/alt-p9-kde5-tegra \
	vm/alt-p9-lxqt-tegra \
	vm/alt-p9-mate-tegra vm/alt-p9-xfce-tegra: \
	vm/alt-p9-%-tegra: vm/regular-%-tegra mixin/p9; @:

# DBM BE-M1000
vm/alt-p9-gnome3-dbm vm/alt-p9-xfce-dbm: \
	vm/alt-p9-%-dbm: vm/regular-%-dbm mixin/p9; @:
endif

ifeq (,$(filter-out armh,$(ARCH)))
vm/alt-p9-lxde-mcom02 vm/alt-p9-lxqt-mcom02 \
	vm/alt-p9-mate-mcom02 vm/alt-p9-xfce-mcom02: \
	vm/alt-p9-%-mcom02: vm/regular-%-mcom02 mixin/p9; @:

vm/alt-p9-lxde-mcom02-mali vm/alt-p9-lxqt-mcom02-mali \
	vm/alt-p9-mate-mcom02-mali vm/alt-p9-xfce-mcom02-mali: \
	vm/alt-p9-%-mcom02-mali: vm/regular-%-mcom02-mali mixin/p9; @:
endif
endif

ifeq (,$(filter-out mipsel,$(ARCH)))
vm/alt-p9-jeos-systemd-tavolga vm/alt-p9-jeos-sysv-tavolga \
	vm/alt-p9-builder-tavolga: \
	vm/alt-p9-%-tavolga: vm/regular-%-tavolga mixin/p9; @:

vm/alt-p9-lxde-tavolga vm/alt-p9-lxqt-tavolga \
	vm/alt-p9-mate-tavolga vm/alt-p9-xfce-tavolga \
	vm/alt-p9-icewm-sysv-tavolga: \
	vm/alt-p9-%-tavolga: vm/regular-%-tavolga mixin/p9; @:

vm/alt-p9-jeos-systemd-bfk3 vm/alt-p9-jeos-sysv-bfk3 \
	vm/alt-p9-builder-bfk3: \
	vm/alt-p9-%-bfk3: vm/regular-%-bfk3 mixin/p9; @:

vm/alt-p9-lxde-bfk3 vm/alt-p9-lxqt-bfk3 vm/alt-p9-mate-bfk3 \
	vm/alt-p9-xfce-bfk3 vm/alt-p9-icewm-sysv-bfk3: \
	vm/alt-p9-%-bfk3: vm/regular-%-bfk3 mixin/p9; @:
endif

endif
