# hooked from ../../lib/sugar.mk
use/build-vm: sub/rootfs@/ use/kernel use/deflogin
	@$(call add_feature)
