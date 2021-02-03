use/mipsel-bfk3: use/kernel use/tty/S0 use/net-eth/dhcp/timeout/20
	@$(call add_feature)
	@$(call set,KFLAVOURS,bfk3-def)
	@$(call set,DTB_NAME,baikal/baikal_bfk3.dtb)
	@$(call xport,DTB_NAME)
	@$(call set,VM_FSTYPE,ext2)
	@$(call add,NET_ETH,eth0:dhcp)
	@$(call add,NET_ETH,eth1:dhcp)
	@$(call add,NET_ETH,eth2:dhcp)
	@$(call add,THE_PACKAGES,fbset-modes-sm750-bfk3)
	@$(call add,THE_PACKAGES,alt-config-be-t)

use/mipsel-bfk3/x11: use/mipsel-bfk3 use/x11/radeon; @:
