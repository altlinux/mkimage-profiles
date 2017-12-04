# p8 base kits

mixin/p8: use/browser/firefox/esr
	@$(call set,BRANDING,alt-starterkit)
	@$(call set,IMAGE_FLAVOUR,$(subst alt-p8-,,$(IMAGE_NAME)))
	@$(call set,META_VOL_ID,ALT p8 $$(IMAGE_FLAVOUR)/$(ARCH))

ifeq (distro,$(IMAGE_CLASS))

distro/alt-p8-cinnamon: distro/regular-cinnamon mixin/p8; @:
distro/alt-p8-icewm: distro/regular-icewm mixin/p8; @:
distro/alt-p8-gnome3: distro/regular-gnome3 mixin/p8; @:
distro/alt-p8-gnustep: distro/regular-gnustep mixin/p8; @:
distro/alt-p8-kde4: distro/regular-kde4 mixin/p8; @:
distro/alt-p8-kde5: distro/regular-kde5 mixin/p8; @:
distro/alt-p8-lxde: distro/regular-lxde mixin/p8; @:
distro/alt-p8-lxde-sysv: distro/regular-lxde-sysv mixin/p8; @:
distro/alt-p8-lxqt: distro/regular-lxqt mixin/p8; @:
distro/alt-p8-lxqt-sysv: distro/regular-lxqt-sysv mixin/p8; @:
distro/alt-p8-mate: distro/regular-mate mixin/p8; @:
distro/alt-p8-rescue: distro/regular-rescue mixin/p8; @:
distro/alt-p8-tde: distro/regular-tde mixin/p8; @:
distro/alt-p8-tde-sysv: distro/regular-tde-sysv mixin/p8; @:
distro/alt-p8-wmaker: distro/regular-wmaker mixin/p8; @:
distro/alt-p8-xfce: distro/regular-xfce mixin/p8; @:
distro/alt-p8-xfce-sysv: distro/regular-xfce-sysv mixin/p8; @:
distro/alt-p8-enlightenment: distro/regular-enlightenment mixin/p8; @:
distro/alt-p8-sysv-tde: distro/regular-sysv-tde mixin/p8; @:
distro/alt-p8-sysv-xfce: distro/regular-sysv-xfce mixin/p8; @:

distro/alt-p8-jeos: distro/regular-jeos mixin/p8; @:
distro/alt-p8-jeos-ovz: distro/regular-jeos-ovz mixin/p8; @:
distro/alt-p8-server: distro/regular-server mixin/p8; @:
distro/alt-p8-server-ovz: distro/regular-server-ovz mixin/p8; @:
distro/alt-p8-server-hyperv: distro/regular-server-hyperv mixin/p8; @:
distro/alt-p8-server-samba4: distro/regular-server-samba4 mixin/p8; @:
distro/alt-p8-server-openstack: distro/regular-server-openstack mixin/p8; @:
distro/alt-p8-server-pve: distro/regular-server-pve mixin/p8; @:

distro/alt-p8-builder: distro/regular-builder mixin/p8; @:

distro/alt-p8-engineering: distro/regular-engineering mixin/p8; @:
endif

ifeq (ve,$(IMAGE_CLASS))
ve/alt-p8-ovz-generic: ve/generic mixin/p8; @:
endif

ifeq (vm,$(IMAGE_CLASS))
vm/alt-p8-vm-net: vm/net mixin/p8; @:
vm/alt-p8-cloud: vm/cloud-systemd mixin/p8; @:
vm/alt-p8-opennebula: vm/opennebula-systemd mixin/p8; @:
endif
