# hooked from lib/sugar.mk
use/build-vm: sub/rootfs@/ use/kernel
	@$(call add_feature)
