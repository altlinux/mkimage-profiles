ifeq (armh,$(ARCH))

ifeq (ve,$(IMAGE_CLASS))

ve/.tegra3-base: ve/.base use/armh use/kernel
	@$(call add,BASE_PACKAGES,nvidia-tegra)

ve/.tegra3-tablet: ve/.tegra3-base use/armh-tegra3
	@$(call add,BASE_LISTS,$(call tags,base tablet))

ve/.nexus7-tablet: ve/.tegra3-tablet use/armh-nexus7 \
	use/x11-autologin use/deflogin/altlinuxroot
	@$(call set,KFLAVOURS,grouper)	# fits tilapia just fine
	@$(call set,BRANDING,altlinux-kdesktop)	### the only suitable so far
	@$(call add,BASE_PACKAGES,mkinitrd)     ### rootsubdir support
	@$(call add,BASE_PACKAGES,firmware-nexus7)
	@$(call add,BASE_PACKAGES,livecd-ru)	### until l10n is there

ve/nexus7-e17: ve/.nexus7-tablet use/x11/e17 use/x11/lightdm/gtk; @:

ve/nexus7-kde4: ve/.nexus7-tablet use/x11/lightdm/kde +systemd
	@$(call add,BASE_LISTS,$(call tags,base kde4mobile))

ve/nexus7-xfce: ve/.nexus7-tablet use/x11/xfce use/x11/lightdm/gtk +systemd
	@$(call add,BASE_PACKAGES,florence at-spi2-atk)

endif

endif
