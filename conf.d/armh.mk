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

ifeq (vm,$(IMAGE_CLASS))

# NB: early dependency on use/kernel is on intent
vm/.arm-base: profile/bare use/kernel use/vm-net/dhcp use/vm-ssh; @:
	@$(call add,BASE_PACKAGES,interactivesystem e2fsprogs)
	@$(call add,BASE_PACKAGES,apt)
	@$(call add,BASE_PACKAGES,mkinitrd uboot-tools)
	@$(call set,BRANDING,altlinux-kdesktop)

vm/.cubox-base: vm/.arm-base use/armh use/armh-cubox use/deflogin/altlinuxroot \
	use/services/ssh use/cleanup/installer use/repo use/branding +systemd
	@$(call set,KFLAVOURS,cubox)
	@$(call set,BRANDING,altlinux-kdesktop)
	@$(call add,THE_BRANDING,alterator graphics indexhtml menu notes)
	@$(call add,BASE_PACKAGES,glibc-locales vim-console rsync)
	@$(call add,BASE_PACKAGES,parole gst-ffmpeg gst-plugins-vmeta)
	@$(call add,BASE_PACKAGES,gst-plugins-good gst-plugins-nice)
	@$(call add,BASE_PACKAGES,gst-plugins-bad gst-plugins-ugly)
	@$(call add,BASE_PACKAGES,fonts-ttf-droid fonts-ttf-ubuntu-font-family)
	@$(call add,BASE_PACKAGES,fonts-ttf-liberation fonts-ttf-dejavu)
	@$(call add,BASE_LISTS,$(call tags,(base || desktop) && regular))

vm/.cubox-gtk: vm/.cubox-base use/x11/lightdm/gtk; @:

vm/cubox-e17: vm/.cubox-gtk use/x11/e17
	@$(call add,BASE_PACKAGES,xterm)

vm/cubox-xfce: vm/.cubox-gtk use/x11/xfce
	@$(call set,BRANDING,simply-linux)
	@$(call add,THE_BRANDING,xfce-settings)
	@$(call add,BASE_LISTS,slinux/arm)

vm/cubox-xfce-ru: vm/cubox-xfce
	@$(call add,BASE_PACKAGES,livecd-ru)
	@$(call add,BASE_PACKAGES,LibreOffice4-full LibreOffice4-langpack-ru)

vm/cubox-mate: vm/.cubox-gtk use/x11/mate
	@$(call add,BASE_LISTS,$(call tags,desktop nm))

endif

endif
