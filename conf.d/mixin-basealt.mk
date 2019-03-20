# shared across all supported arches, can be complemented per arch

mixin/alt-workstation: workstation_groups = $(addprefix workstation/,\
	10-office 20-networking 30-multimedia 40-virtualization 50-publishing \
	agents emulators ganttproject gnome-peer-to-peer graphics-editing \
	libreoffice mate-usershare pidgin raccess scanning scribus \
	sound-editing thunderbird vlc freeipa-client)

mixin/alt-workstation: +installer +systemd +pulse +nm \
	use/kernel/net use/l10n/default/ru_RU \
	use/x11/xorg use/x11-autostart use/x11/gtk/nm \
	use/install2/fs use/install2/fat use/install2/vnc \
	use/apt-conf/branch use/volumes/regular \
	use/fonts/install2 \
	use/fonts/otf/adobe use/fonts/otf/mozilla \
	use/fonts/ttf/google use/fonts/ttf/google/extra \
	use/fonts/ttf/redhat use/fonts/ttf/ubuntu \
	use/branding use/control use/services \
	use/sound use/xdg-user-dirs \
	use/docs/manual use/docs/indexhtml \
	use/browser/firefox use/browser/firefox/esr
	@$(call set,BRANDING,alt-workstation)
	@$(call add,THE_BRANDING,mate-settings)
	@$(call add,STAGE1_MODLISTS,stage2-mmc)
	@$(call set,INSTALLER,altlinux-desktop)
	@$(call add,INSTALL2_PACKAGES,alterator-notes)
	@$(call add,INSTALL2_PACKAGES,fdisk)
	@$(call add,COMMON_PACKAGES,vim-console)
	@$(call add,MAIN_GROUPS,$(workstation_groups))
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
	@$(call add,THE_KMODULES,staging)
	@$(call add,CLEANUP_PACKAGES,xterm)
	@$(call set,GLOBAL_LIVE_NO_CLEANUPDB,true)
	@$(call add,CONTROL,xdg-user-dirs:enabled)
	@$(call add,SERVICES_ENABLE,sshd)
	@$(call add,SERVICES_ENABLE,cups smb nmb httpd2 bluetoothd libvirtd)
	@$(call add,DEFAULT_SERVICES_ENABLE,fstrim.timer)
	@$(call add,DEFAULT_SERVICES_DISABLE,powertop bridge gpm)
	@$(call set,META_PUBLISHER,BaseALT Ltd)
	@$(call set,META_VOL_SET,ALT)
	@$(call set,META_VOL_ID,ALT Workstation)
	@$(call set,META_APP_ID,$(DISTRO_VERSION)/$(ARCH))
	@$(call set,DOCS,alt-workstation)
