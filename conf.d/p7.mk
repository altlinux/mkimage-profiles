# p7 base kits
ifeq (distro,$(IMAGE_CLASS))

mixin/p7:
	@$(call set,BRANDING,altlinux-starterkit)

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
distro/altlinux-p7-xfce: distro/regular-xfce mixin/p7; @:

endif
