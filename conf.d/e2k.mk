ifeq (vm,$(IMAGE_CLASS))

vm/live-e2k: vm/bare use/e2k use/deflogin/live
	@$(call add,THE_PACKAGES,openssh)
	@$(call add,THE_LISTS,$(call tags,ve tools))

vm/rescue-e2k: vm/live-e2k use/tty/S0 use/net-eth/dhcp use/services/lvm2-disable
	@$(call add,THE_PACKAGES,agetty gpm fdisk parted smartmontools pv sshfs)
	@$(call add,THE_LISTS,$(call tags,server && (network || extra)))
	@$(call add,DEFAULT_SERVICES_DISABLE,gpm mdadm smartd)

endif
