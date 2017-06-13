ifeq (distro,$(IMAGE_CLASS))

distro/alt-workstation: workstation_groups = $(addprefix workstation/,\
	10-office 20-networking 30-multimedia 40-virtualization 50-publishing \
	3rdparty agents blender clamav cloud-clients emulators freecad \
	ganttproject gnome-peer-to-peer graphics-editing gtk-dictionary \
	kvm libreoffice mate-usershare pidgin raccess \
	scanning scribus smartcard sound-editing thunderbird virtualbox \
	vlc voip-clients)

distro/alt-workstation: distro/.base use/luks  \
	+installer +power +systemd +pulse +vmguest +wireless +efi \
	use/kernel/net use/docs/license \
	use/memtest use/bootloader/grub \
	use/install2/fs use/install2/vnc use/install2/repo \
	use/install2/suspend use/x11/xorg use/sound use/xdg-user-dirs \
	mixin/desktop-installer \
	use/efi/refind use/efi/memtest86 use/efi/shell use/rescue/base \
	use/branding/complete \
	use/fonts/install2 use/install2/fs \
	use/fonts/otf/adobe use/fonts/otf/mozilla \
	use/fonts/ttf/google/extra use/fonts/ttf/redhat use/fonts/ttf/ubuntu \
	use/l10n/default/ru_RU \
	use/control use/services \
	use/live/install use/live/suspend use/live/x11 use/live/repo \
	use/live/rw \
	use/x11/lightdm/gtk use/docs/manual use/x11/gtk/nm +nm \
	use/fonts/ttf/google use/domain-client/full \
	use/browser/firefox use/browser/firefox/esr
	@$(call set,BRANDING,alt-workstation)
	@$(call add,THE_BRANDING,mate-settings)
	@$(call add,STAGE1_MODLISTS,stage2-mmc)
	@$(call set,INSTALLER,altlinux-desktop)
	@$(call add,INSTALL2_PACKAGES,alterator-notes)
	@$(call add,INSTALL2_PACKAGES,volumes-profile-regular)
	@$(call add,INSTALL2_PACKAGES,open-iscsi)
	@$(call add,COMMON_PACKAGES,vim-console)
	@$(call add,MAIN_PACKAGES,solaar)
	@$(call add,MAIN_GROUPS,$(workstation_groups))
	@$(call add,MAIN_LISTS,workstation/extras)
	@$(call add,MAIN_LISTS,$(call tags,xorg vaapi))
	@$(call add,BASE_LISTS,workstation/base.pkgs)
	@$(call add,BASE_LISTS,$(call tags,desktop cups))
	@$(call add,LIVE_LISTS,workstation/live.pkgs)
	@$(call add,LIVE_LISTS,$(call tags,desktop sane))
	@$(call add,LIVE_LISTS,$(call tags,desktop office))
	@$(call add,THE_LISTS,workstation/mate)
	@$(call add,THE_LISTS,workstation/the.pkgs)
	@$(call add,THE_LISTS,$(call tags,regular desktop))
	@$(call add,THE_LISTS,$(call tags,base regular))
	@$(call add,THE_LISTS,$(call tags,base l10n))
	@$(call add,THE_LISTS,$(call tags,base desktop))
	@$(call add,THE_LISTS,$(call tags,archive extra))
	@$(call add,THE_LISTS,$(call tags,mobile mate))
	@$(call add,THE_KMODULES,staging)
	@$(call add,BASE_KMODULES,kvm virtualbox)
	@$(call add,CLEANUP_BASE_PACKAGES,acpid-events-power)
	@$(call add,CLEANUP_PACKAGES,xterm)
	@$(call add,EFI_BOOTARGS,lang=ru_RU)
	@$(call add,RESCUE_BOOTARGS,nomodeset vga=0)
	@$(call add,CONTROL,xdg-user-dirs:enabled)
	@$(call add,SERVICES_ENABLE,sshd)
	@$(call add,SERVICES_ENABLE,cups smb nmb httpd2 bluetoothd libvirtd)
	@$(call add,DEFAULT_SERVICES_ENABLE,fstrim.timer)
	@$(call add,DEFAULT_SERVICES_DISABLE,powertop bridge gpm)
	@$(call set,META_PUBLISHER,BaseALT Ltd)
	@$(call set,META_VOL_SET,ALT)
	@$(call set,META_VOL_ID,ALT Workstation)
	@$(call set,META_APP_ID,8.1/$(ARCH))
	@$(call set,DOCS,alt-workstation)

endif
