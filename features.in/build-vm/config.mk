# hooked from lib/sugar.mk
use/build-vm: sub/rootfs@/ use/kernel/initrd-setup
	@$(call add_feature)
	@$(call set,GLOBAL_HSH_PROC,1)
