# virtual machines
ifeq (vm,$(IMAGE_CLASS))

vm/bare: vm/.bare
	@$(call add,BASE_PACKAGES,apt)

vm/net: vm/bare use/net-eth/dhcp use/net-ssh
	@$(call add,BASE_PACKAGES,su)

# NB: use/x11 employs some installer-feature packages
vm/icewm: vm/net use/cleanup/installer use/repo use/deflogin/altlinuxroot \
	use/x11/xorg use/x11/lightdm/gtk use/x11-autologin +icewm; @:

endif
