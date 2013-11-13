# p7 base kits

mixin/p7:
	@$(call set,BRANDING,altlinux-starterkit)

ifeq (distro,$(IMAGE_CLASS))

### kludge compatibility: introspection stub for ../main.mk :-/
distro/altlinux-p7-cinnamon: distro/regular-cinnamon mixin/p7; @:
distro/altlinux-p7-e17: distro/regular-e17 mixin/p7; @:
distro/altlinux-p7-icewm: distro/regular-icewm mixin/p7; @:
distro/altlinux-p7-gnome3: distro/regular-gnome3 mixin/p7; @:
distro/altlinux-p7-kde4: distro/regular-kde4 mixin/p7; @:
distro/altlinux-p7-lxde: distro/regular-lxde mixin/p7; @:
distro/altlinux-p7-mate: distro/regular-mate mixin/p7; @:
distro/altlinux-p7-razorqt: distro/regular-razorqt mixin/p7; @:
distro/altlinux-p7-rescue: distro/regular-rescue mixin/p7; @:
distro/altlinux-p7-tde: distro/regular-tde mixin/p7; @:
distro/altlinux-p7-tde-sysv: distro/regular-tde-sysv mixin/p7; @:
distro/altlinux-p7-wmaker: distro/regular-wmaker mixin/p7; @:
distro/altlinux-p7-xfce: distro/regular-xfce mixin/p7; @:

distro/altlinux-p7-sysv-tde: distro/regular-sysv-tde mixin/p7; @:

distro/altlinux-p7-server: distro/regular-server mixin/p7; @:

endif

ifeq (ve,$(IMAGE_CLASS))
ve/altlinux-p7: ve/generic mixin/p7; @:
endif
