ifeq (armh,$(ARCH))

ifeq (ve,$(IMAGE_CLASS))

ve/.tegra3-base: ve/.base use/armh use/kernel
	@$(call add,BASE_PACKAGES,nvidia-tegra)

ve/.tegra3-tablet: ve/.tegra3-base use/armh-tegra3 +pulse
	@$(call add,BASE_LISTS,$(call tags,base tablet))

ve/.nexus7-tablet: ve/.tegra3-tablet use/armh-nexus7 \
	use/x11-autologin use/deflogin/altlinuxroot
	@$(call set,KFLAVOURS,grouper)	# fits tilapia just fine
	@$(call set,BRANDING,altlinux-kdesktop)	### the only suitable so far
	@$(call add,BASE_PACKAGES,mkinitrd)     ### rootsubdir support
	@$(call add,BASE_PACKAGES,firmware-nexus7)
	@$(call add,BASE_PACKAGES,livecd-ru)	### until l10n is there

ve/nexus7-xfce: ve/.nexus7-tablet use/x11/xfce use/x11/lightdm/gtk +systemd
	@$(call add,BASE_PACKAGES,florence at-spi2-atk)

endif

ifeq (vm,$(IMAGE_CLASS))

# NB: early dependency on use/kernel is on intent
vm/.arm-base: profile/bare use/kernel use/net-eth/dhcp use/net-ssh; @:
	@$(call add,BASE_PACKAGES,interactivesystem e2fsprogs)
	@$(call add,BASE_PACKAGES,apt)
	@$(call add,BASE_PACKAGES,mkinitrd uboot-tools)
	@$(call set,BRANDING,altlinux-kdesktop)

vm/.cubox-bare: vm/.arm-base use/armh-cubox use/net-ssh use/repo use/tty/S0
	@$(call add,BASE_PACKAGES,glibc-locales vim-console rsync)

vm/.cubox-desktop: vm/.cubox-bare use/armh-dovefb +systemd +pulse \
	use/armh-cubox use/branding use/xdg-user-dirs/deep \
	use/fonts/otf/adobe use/fonts/ttf/redhat use/fonts/ttf/ubuntu
	@$(call set,BRANDING,altlinux-kdesktop)
	@$(call add,THE_BRANDING,alterator graphics indexhtml menu notes)
	@$(call add,BASE_PACKAGES,parole gst-ffmpeg gst-plugins-vmeta)
	@$(call add,BASE_PACKAGES,gst-plugins-good gst-plugins-nice)
	@$(call add,BASE_PACKAGES,gst-plugins-bad gst-plugins-ugly)
	@$(call add,BASE_PACKAGES,LibreOffice4-full LibreOffice4-langpack-ru)
	@$(call add,BASE_LISTS,$(call tags,(base || desktop) && regular))

vm/cubox-xfce-ru: vm/.cubox-desktop use/deflogin/altlinuxroot \
	use/slinux/arm use/x11/lightdm/gtk use/x11-autologin +nm
	@$(call add,BASE_PACKAGES,livecd-ru)

# these images use a kind of OEM setup
vm/.cubox-oem: vm/.cubox-desktop use/oem; @:

vm/.cubox-gtk: vm/.cubox-oem use/x11/lightdm/gtk +nm; @:

vm/cubox-xfce: vm/.cubox-gtk \
	use/slinux/arm use/net-usershares use/domain-client; @:

vm/cubox-mate: vm/.cubox-gtk use/x11/mate; @:
	@$(call set,BRANDING,altlinux-centaurus)
	@$(call add,THE_BRANDING,mate-settings)

vm/cubox-server: vm/.cubox-bare use/deflogin/altlinuxroot use/control/sudo-su \
	+sysvinit
	@$(call set,BRANDING,altlinux-centaurus)
	@$(call add,BASE_PACKAGES,agetty fdisk)
	@$(call add,BASE_LISTS,$(call tags,base security))

vm/arm-server: vm/.arm-base use/net-eth/dhcp use/cleanup/installer +sysvinit
	@$(call set,KFLAVOURS,armadaxp)
	@$(call add,BASE_PACKAGES,agetty)
	@$(call add,BASE_LISTS,$(call tags,extra (server || network)))

endif

endif
