# virtual machines
ifeq (vm,$(IMAGE_CLASS))

vm/net: vm/bare use/vm-net/dhcp use/vm-ssh use/repo
	@$(call set,VM_SIZE,5368709120)	# 5 Gb is enough for everyone

# NB: use/x11 employs some installer-feature packages
vm/icewm: vm/net use/cleanup/installer +icewm; @:

endif
