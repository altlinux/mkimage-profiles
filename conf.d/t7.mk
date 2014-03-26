# t7 base kits

mixin/t7:
	@$(call set,BRANDING,altlinux-starterkit) ### needs changing

ifeq (distro,$(IMAGE_CLASS))

distro/altlinux-t7-gnustep: distro/regular-gnustep mixin/t7; @:
distro/altlinux-t7-gnustep-systemd: distro/regular-gnustep-systemd mixin/t7; @:
distro/altlinux-t7-tde: distro/regular-tde mixin/t7; @:
distro/altlinux-t7-sysv-tde: distro/regular-sysv-tde mixin/t7; @:

endif
