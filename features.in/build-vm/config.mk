# hooked from lib/sugar.mk
use/build-vm: sub/rootfs@/ use/kernel/initrd-setup
	@$(call add_feature)
