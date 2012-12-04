# simply images

ifeq (distro,$(IMAGE_CLASS))

distro/live-simply: distro/.livecd-install use/slinux/full
	@$(call add,THE_LISTS,slinux/live-install)

distro/simply: distro/.installer use/slinux/full
	@$(call set,INSTALLER,simply-linux)
	@$(call add,INSTALL2_PACKAGES,sysvinit)

endif
