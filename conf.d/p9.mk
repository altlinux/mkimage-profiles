# p9 base kits

mixin/p9: use/browser/firefox/esr
	@$(call set,BRANDING,alt-starterkit)
	@$(call set,IMAGE_FLAVOUR,$(subst alt-p9-,,$(IMAGE_NAME)))
	@$(call set,META_VOL_ID,ALT p9 $$(IMAGE_FLAVOUR)/$(ARCH))

ifeq (distro,$(IMAGE_CLASS))

distro/alt-p9-cinnamon distro/alt-p9-enlightenment \
	distro/alt-p9-gnome3 distro/alt-p9-gnustep \
	distro/alt-p9-icewm distro/alt-p9-kde5 \
	distro/alt-p9-lxde distro/alt-p9-lxde-sysv \
	distro/alt-p9-lxqt distro/alt-p9-lxqt-sysv \
	distro/alt-p9-mate distro/alt-p9-rescue \
	distro/alt-p9-wmaker distro/alt-p9-xfce \
	distro/alt-p9-xfce-sysv distro/alt-p9-sysv-xfce: \
	distro/alt-p9-%: distro/regular-% mixin/p9; @:

distro/alt-p9-jeos distro/alt-p9-jeos-ovz \
	distro/alt-p9-server distro/alt-p9-server-ovz \
	distro/alt-p9-server-hyperv distro/alt-p9-server-samba4 \
	distro/alt-p9-server-pve distro/alt-p9-server-lxd: \
	distro/alt-p9-%: distro/regular-% mixin/p9; @:

distro/alt-p9-builder: distro/regular-builder mixin/p9; @:

distro/alt-p9-engineering: distro/regular-engineering mixin/p9; @:
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
	vm/alt-p9-cinnamon vm/alt-p9-kde5 \
	vm/alt-p9-icewm vm/alt-p9-lxde \
	vm/alt-p9-lxqt vm/alt-p9-mate \
	vm/alt-p9-xfce: \
	vm/alt-p9-%: vm/regular-% mixin/p9; @:

ifeq (,$(filter-out aarch64,$(ARCH)))
vm/alt-p9-cinnamon-tegra vm/alt-p9-kde5-tegra \
	vm/alt-p9-lxde-tegra vm/alt-p9-lxqt-tegra \
	vm/alt-p9-mate-tegra vm/alt-p9-xfce-tegra: \
	vm/alt-p9-%-tegra: vm/regular-%-tegra mixin/p9; @:
endif

ifeq (,$(filter-out armh,$(ARCH)))
vm/alt-p9-lxde-mcom02 vm/alt-p9-lxqt-mcom02 \
	vm/alt-p9-mate-mcom02 vm/alt-p9-xfce-mcom02: \
	vm/alt-p9-%-mcom02: vm/regular-%-mcom02 mixin/p9; @:

vm/alt-p9-lxde-mcom02-mali vm/alt-p9-lxqt-mcom02-mali \
	vm/alt-p9-mate-mcom02-mali vm/alt-p9-xfce-mcom02-mali: \
	vm/alt-p9-%-mcom02-mali: vm/regular-%-mcom02-mali mixin/p9; @:
endif

ifeq (,$(filter-out mipsel,$(ARCH)))
vm/tavolga-alt-p9-jeos-systemd vm/tavolga-alt-p9-jeos-sysv \
	vm/tavolga-alt-p9-builder: \
	vm/tavolga-alt-p9-%: vm/tavolga-regular-% mixin/p9; @:

vm/tavolga-alt-p9-lxde vm/tavolga-alt-p9-lxqt \
	vm/tavolga-alt-p9-mate vm/tavolga-alt-p9-xfce \
	vm/tavolga-alt-p9-icewm: \
	vm/tavolga-alt-p9-%: vm/tavolga-regular-% mixin/p9; @:

vm/bfk3-alt-p9-jeos-systemd vm/bfk3-alt-p9-jeos-sysv \
	vm/bfk3-alt-p9-builder: \
	vm/bfk3-alt-p9-%: vm/bfk3-regular-% mixin/p9; @:

vm/bfk3-alt-p9-lxde vm/bfk3-alt-p9-lxqt vm/bfk3-alt-p9-mate \
	vm/bfk3-alt-p9-xfce vm/bfk3-alt-p9-icewm: \
	vm/bfk3-alt-p9-%: vm/bfk3-regular-% mixin/p9; @:
endif

endif
