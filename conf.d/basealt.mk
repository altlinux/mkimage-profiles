ifeq (distro,$(IMAGE_CLASS))

distro/basealt-workstation: workstation_groups = $(addprefix workstation/,\
	10-office 20-networking 30-multimedia 40-virtualization 50-publishing \
	blender emulators gnome-peer-to-peer graphics-editing \
	gtk-dictionary libreoffice mate-usershare pidgin qgis remmina \
	scanning scribus sound-editing vlc \
	freecad ganttproject thunderbird \
	kvm virtualbox)

distro/basealt-workstation: distro/.base use/luks  \
	+installer +sysvinit +power +systemd +pulse +vmguest +wireless +efi \
	use/kernel/net use/docs/license \
	use/vmguest use/memtest \
	use/bootloader/grub \
	use/install2/fs use/install2/vnc use/install2/repo \
	use/install2/suspend use/x11/xorg use/sound use/xdg-user-dirs \
	mixin/desktop-installer \
	use/efi/refind use/efi/shell use/rescue/base \
	use/branding use/syslinux/ui/gfxboot use/plymouth/full \
	use/fonts/install2 use/install2/fs \
	use/fonts/otf/adobe use/fonts/otf/mozilla \
	use/fonts/ttf/google/extra use/fonts/ttf/redhat use/fonts/ttf/ubuntu \
	use/l10n/default/ru_RU \
	use/control use/services \
	use/live/install use/live/suspend use/live/x11 use/live/repo \
	use/x11/lightdm/gtk use/docs/manual use/x11/gtk/nm +nm \
	use/fonts/ttf/google use/domain-client/full \
	use/browser/firefox use/browser/firefox/esr
	@$(call add,THE_PACKAGES,installer-feature-desktop-other-fs-stage2)
	@$(call add,THE_PACKAGES,alterator-notes)
	@$(call add,THE_PACKAGES,imagewriter)
	@$(call add,THE_PACKAGES,mintmenu)
	@$(call add,THE_PACKAGES,firefox-esr-ru)
	@$(call add,THE_PACKAGES,systemd-udev-console-fb)
	@$(call add,THE_BRANDING,graphics)
	@$(call add,THE_BRANDING,alterator bootloader bootsplash graphics)
	@$(call add,THE_BRANDING,notes slideshow)
	@$(call add,INSTALL2_BRANDING,notes slideshow)
	@$(call add,THE_LISTS,$(call tags,base regular))
	@$(call add,INSTALL2_BRANDING,alterator notes)
	@$(call add,INSTALL2_PACKAGES,alterator-notes)
	@$(call add,THE_LISTS,$(call tags,regular desktop))
	@$(call add,MAIN_GROUPS,$(workstation_groups))
	@$(call add,BASE_LISTS,$(call tags,desktop cups))
	@$(call add,LIVE_LISTS,$(call tags,desktop sane))
	@$(call add,LIVE_LISTS,$(call tags,desktop office))
	@$(call add,THE_LISTS,workstation/mate)
	@$(call add,THE_LISTS,$(call tags,base l10n))
	@$(call add,THE_LISTS,$(call tags,base desktop))
	@$(call add,THE_LISTS,$(call tags,archive extra))
	@$(call add,THE_LISTS,$(call tags,mobile mate))
	@$(call add,LIVE_PACKAGES,virt-viewer vlc)
	@$(call add,LIVE_PACKAGES,volumes-profile-regular)
	@$(call add,INSTALL2_PACKAGES,volumes-profile-regular)
	@$(call add,THE_PACKAGES,bluez pulseaudio-bluez rpminstall)
	@$(call add,BASE_PACKAGES,installer-feature-centaurus-keyring)
	@$(call add,BASE_PACKAGES,samba-winbind)
	@$(call add,BASE_PACKAGES,alterator-x11)
	@$(call add,COMMON_PACKAGES,vim-console)
	@$(call add,LIVE_PACKAGES,xterm-)
	@$(call add,CLEANUP_PACKAGES,xterm)
	@$(call add,BASE_KMODULES,kvm virtualbox)
	@$(call add,THE_KMODULES,staging)
	@$(call add,THE_BRANDING,mate-settings)
	@$(call set,BRANDING,basealt-workstation)
	@$(call set,INSTALLER,altlinux-desktop)
	@$(call set,DOCS,basealt-desktop)
	@$(call add,RESCUE_BOOTARGS,nomodeset vga=0)
	@$(call add,CONTROL,xdg-user-dirs:enabled)
	@$(call add,SERVICES_ENABLE,cups smb nmb httpd2)
	@$(call add,DEFAULT_SERVICES_ENABLE,powertop)
	@$(call set,META_PUBLISHER,BaseALT Ltd)
	@$(call set,META_VOL_SET,BaseALT)
	@$(call set,META_VOL_ID,BaseALT Workstation)
	@$(call set,META_APP_ID,8.0/$(ARCH))

distro/alt-workstation: distro/basealt-workstation
	@$(call set,BRANDING,alt-workstation)

endif
