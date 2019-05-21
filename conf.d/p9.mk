# p9 base kits

mixin/p9: use/browser/firefox/esr
	@$(call set,BRANDING,alt-starterkit)
	@$(call set,IMAGE_FLAVOUR,$(subst alt-p9-,,$(IMAGE_NAME)))
	@$(call set,META_VOL_ID,ALT p9 $$(IMAGE_FLAVOUR)/$(ARCH))

ifeq (distro,$(IMAGE_CLASS))

distro/alt-p9-cinnamon: distro/regular-cinnamon mixin/p9; @:
distro/alt-p9-icewm: distro/regular-icewm mixin/p9; @:
distro/alt-p9-gnome3: distro/regular-gnome3 mixin/p9; @:
distro/alt-p9-gnustep: distro/regular-gnustep mixin/p9; @:
distro/alt-p9-kde5: distro/regular-kde5 mixin/p9; @:
distro/alt-p9-lxde: distro/regular-lxde mixin/p9; @:
distro/alt-p9-lxde-sysv: distro/regular-lxde-sysv mixin/p9; @:
distro/alt-p9-lxqt: distro/regular-lxqt mixin/p9; @:
distro/alt-p9-lxqt-sysv: distro/regular-lxqt-sysv mixin/p9; @:
distro/alt-p9-mate: distro/regular-mate mixin/p9; @:
distro/alt-p9-rescue: distro/regular-rescue mixin/p9; @:
distro/alt-p9-wmaker: distro/regular-wmaker mixin/p9; @:
distro/alt-p9-xfce: distro/regular-xfce mixin/p9; @:
distro/alt-p9-xfce-sysv: distro/regular-xfce-sysv mixin/p9; @:
distro/alt-p9-enlightenment: distro/regular-enlightenment mixin/p9; @:
distro/alt-p9-sysv-xfce: distro/regular-sysv-xfce mixin/p9; @:

distro/alt-p9-jeos: distro/regular-jeos mixin/p9; @:
distro/alt-p9-jeos-ovz: distro/regular-jeos-ovz mixin/p9; @:
distro/alt-p9-server: distro/regular-server mixin/p9; @:
distro/alt-p9-server-ovz: distro/regular-server-ovz mixin/p9; @:
distro/alt-p9-server-hyperv: distro/regular-server-hyperv mixin/p9; @:
distro/alt-p9-server-samba4: distro/regular-server-samba4 mixin/p9; @:
distro/alt-p9-server-openstack: distro/regular-server-openstack mixin/p9; @:
distro/alt-p9-server-pve: distro/regular-server-pve mixin/p9; @:
distro/alt-p9-server-lxd: distro/regular-server-lxd mixin/p9; @:

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
vm/alt-p9-jeos-systemd: vm/regular-jeos-systemd mixin/p9
vm/alt-p9-jeos-sysv: vm/regular-jeos-sysv mixin/p9
vm/alt-p9-icewm: vm/regular-icewm mixin/p9
vm/alt-p9-lxde: vm/regular-icewm mixin/p9
vm/alt-p9-lxqt: vm/regular-lxqt mixin/p9
vm/alt-p9-mate: vm/regular-mate mixin/p9
vm/alt-p9-xfce: vm/regular-xfce mixin/p9

endif
