# live images
ifeq (distro,$(IMAGE_CLASS))

distro/live: distro/.base use/live/base
distro/rescue: distro/.base use/rescue use/syslinux/ui-menu
distro/dos: distro/.init use/dos use/syslinux/ui-menu

distro/live-builder: distro/.base sub/main \
	use/live/base use/dev/mkimage
	@$(call add,LIVE_LISTS,$(call tags,base && (server || builder)))
	@$(call add,LIVE_PACKAGES,livecd-tmpfs livecd-online-repo)
	@$(call add,LIVE_PACKAGES,mkimage-profiles)
	@$(call add,LIVE_PACKAGES,zsh sudo apt-repo)
	@$(call add,MAIN_PACKAGES,rpm-build basesystem)
	@$(call add,MAIN_PACKAGES,fakeroot sisyphus_check)
	@$(call add,MAIN_PACKAGES,syslinux pciids memtest86+ mkisofs)
	@$(call add,MAIN_PACKAGES,file make-initrd make-initrd-propagator)
	@$(call add,MAIN_PACKAGES,livecd-tmpfs livecd-online-repo)
	@$(call add,MAIN_PACKAGES,mkimage-profiles)

endif
