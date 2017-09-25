ifeq (vm,$(IMAGE_CLASS))

vm/.e2k-bare: vm/.bare use/e2k
	@$(call add,BASE_PACKAGES,apt)

vm/e2k-live: vm/.e2k-bare use/deflogin/live use/net-ssh use/control/sudo-su
	@$(call add,THE_LISTS,$(call tags,ve tools))

vm/e2k-rescue: vm/e2k-live mixin/e2k-base use/services/lvm2-disable
	@$(call add,THE_PACKAGES,agetty gpm fdisk parted smartmontools pv sshfs)
	@$(call add,THE_LISTS,$(call tags,server && (network || extra)))
	@$(call add,DEFAULT_SERVICES_DISABLE,gpm mdadm smartd)

vm/e2k-xfce: vm/e2k-rescue mixin/e2k-desktop use/x11/xfce
	@$(call add,THE_PACKAGES,pnmixer)

vm/e2k-lxqt: vm/e2k-rescue mixin/e2k-desktop
	@$(call add,THE_LISTS,$(call tags,(lxqt desktop) && !extra))

vm/e2k-mate: vm/systemd mixin/e2k-base mixin/e2k-desktop \
	use/deflogin/live use/x11/mate; @:

vm/e2k-builder: vm/e2k-rescue use/dev/builder/base; @:

vm/e2k-samba-DC: vm/e2k-rescue
	@$(call add,BASE_PACKAGES,task-samba-dc glibc-locales net-tools)

endif
