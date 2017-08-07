ifeq (vm,$(IMAGE_CLASS))

vm/e2k-live: vm/bare use/e2k use/deflogin/live use/control/sudo-su
	@$(call add,THE_PACKAGES,openssh)
	@$(call add,THE_LISTS,$(call tags,ve tools))

vm/e2k-rescue: vm/e2k-live use/tty/S0 use/net-eth/dhcp use/services/lvm2-disable
	@$(call add,THE_PACKAGES,agetty gpm fdisk parted smartmontools pv sshfs)
	@$(call add,THE_LISTS,$(call tags,server && (network || extra)))
	@$(call add,DEFAULT_SERVICES_DISABLE,gpm mdadm smartd)

vm/e2k-xfce: vm/e2k-rescue use/e2k/x11 use/x11/xfce \
	use/l10n/default/ru_RU use/fonts/otf/adobe use/fonts/otf/mozilla
	@$(call add,THE_PACKAGES,xinit xterm firefox mc)

endif
