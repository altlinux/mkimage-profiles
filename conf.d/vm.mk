# virtual machines
ifeq (vm,$(IMAGE_CLASS))

# NB: use/x11 employs some installer-feature packages
vm/icewm: vm/bare use/cleanup/installer use/x11/xdm +icewm; @:

vm/net: vm/bare use/vm-net/dhcp use/vm-ssh; @:

vm/net-static: vm/bare use/vm-net/static use/vm-ssh
	@$(call set,VM_NET_IPV4ADDR,10.0.2.16/24)
	@$(call set,VM_NET_IPV4GW,10.0.2.2)

endif
