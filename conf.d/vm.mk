# virtual machines
ifeq (vm,$(IMAGE_CLASS))

vm/icewm: vm/bare use/x11/xdm +icewm; @:

endif
