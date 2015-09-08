# p7 base kits

mixin/p7: use/browser/firefox/esr
	@$(call set,BRANDING,altlinux-starterkit)

ifeq (distro,$(IMAGE_CLASS))

### kludge compatibility: introspection stub for main.mk :-/
distro/altlinux-p7-cinnamon: distro/regular-cinnamon mixin/p7; @:
distro/altlinux-p7-e17: distro/regular-e17 mixin/p7; @:
distro/altlinux-p7-icewm: distro/regular-icewm mixin/p7; @:
distro/altlinux-p7-gnome3: distro/regular-gnome3 mixin/p7; @:
distro/altlinux-p7-gnustep: distro/regular-gnustep mixin/p7; @:
distro/altlinux-p7-kde4: distro/regular-kde4 mixin/p7; @:
distro/altlinux-p7-lxde: distro/regular-lxde mixin/p7; @:
distro/altlinux-p7-lxqt: distro/regular-lxqt mixin/p7; @:
distro/altlinux-p7-lxqt-sysv: distro/regular-lxqt-sysv mixin/p7; @:
distro/altlinux-p7-mate: distro/regular-mate mixin/p7; @:
distro/altlinux-p7-rescue: distro/regular-rescue mixin/p7; @:
distro/altlinux-p7-tde: distro/regular-tde mixin/p7; @:
distro/altlinux-p7-tde-sysv: distro/regular-tde-sysv mixin/p7; @:
distro/altlinux-p7-wmaker: distro/regular-wmaker mixin/p7; @:
distro/altlinux-p7-xfce: distro/regular-xfce mixin/p7; @:
distro/altlinux-p7-xfce-sysv: distro/regular-xfce-sysv mixin/p7; @:

distro/altlinux-p7-sysv-tde: distro/regular-sysv-tde mixin/p7; @:

distro/altlinux-p7-jeos: distro/regular-jeos mixin/p7; @:
distro/altlinux-p7-server: distro/regular-server mixin/p7; @:
distro/altlinux-p7-server-ovz: distro/regular-server-ovz mixin/p7; @:
distro/altlinux-p7-server-hyperv: distro/regular-server-hyperv mixin/p7; @:
distro/altlinux-p7-server-samba4: distro/regular-server-samba4 mixin/p7; @:

distro/altlinux-p7-builder: distro/regular-builder mixin/p7; @:

endif

ifeq (ve,$(IMAGE_CLASS))
ve/altlinux-p7-ovz-generic: ve/generic mixin/p7; @:
ve/altlinux-p7-ovz-pgsql94: ve/pgsql94 mixin/p7; @:
endif

ifeq (vm,$(IMAGE_CLASS))
vm/altlinux-p7-vm-net: vm/net mixin/p7; @:
vm/altlinux-p7-vagrant: vm/vagrant-base mixin/p7; @:
endif
