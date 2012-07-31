# virtual machines
ifeq (vm,$(IMAGE_CLASS))

# NB: use/x11 employs some installer-feature packages
vm/icewm: vm/bare use/cleanup/installer use/x11/xdm +icewm; @:

vm/net: vm/bare use/vm-net/dhcp use/vm-ssh; @:

endif
