# hooked from ../../lib/sugar.mk
use/build-vm: sub/rootfs@/
	@$(call add_feature)
	@$(call xport,ROOTPW)
