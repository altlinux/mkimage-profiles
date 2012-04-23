# simply images

ifeq (distro,$(IMAGE_CLASS))

distro/live-simply: distro/.livecd-install use/isohybrid use/slinux-live use/systemd \
	use/firmware/wireless use/x11/drm use/x11/3d-proprietary use/syslinux/ui/gfxboot
	@$(call set,BRANDING,simply-linux)

endif
