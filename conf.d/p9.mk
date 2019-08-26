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
vm/alt-p9-jeos-systemd vm/alt-p9-jeos-sysv \
	vm/alt-p9-icewm vm/alt-p9-lxde \
	vm/alt-p9-lxqt vm/alt-p9-mate \
	vm/alt-p9-xfce: \
	vm/alt-p9-%: vm/regular-% mixin/p9; @:

endif
