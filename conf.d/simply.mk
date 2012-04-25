# simply images

ifeq (distro,$(IMAGE_CLASS))

distro/live-simply: distro/.livecd-install use/isohybrid use/slinux \
	use/systemd use/firmware/wireless use/x11/drm use/x11/3d-proprietary \
	use/branding/complete
	@$(call add,THE_PACKAGES,apt-conf-sisyphus)
	@$(call add,THE_LISTS,slinux/live-install)
	@$(call add,THE_PACKAGES,apt-conf-sisyphus)	###

endif
