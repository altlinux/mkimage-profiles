# virtual machines
ifeq (vm,$(IMAGE_CLASS))

vm/net: vm/bare use/vm-net/dhcp use/vm-ssh; @:

# NB: use/x11 employs some installer-feature packages
vm/icewm: vm/net use/cleanup/installer use/repo +icewm; @:

endif
