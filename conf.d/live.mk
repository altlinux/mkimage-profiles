# live images
ifeq (distro,$(IMAGE_CLASS))

distro/live: distro/.base use/live use/syslinux/ui-menu
distro/rescue: distro/.base use/rescue use/syslinux/ui-menu
distro/dos: distro/.init use/dos use/syslinux/ui-menu

endif
