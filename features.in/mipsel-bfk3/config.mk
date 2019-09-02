use/mipsel-bfk3: use/kernel use/tty/S0
	@$(call add_feature)
	@$(call set,KFLAVOURS,bfk3-def)
	@$(call set,VM_FSTYPE,ext2)
	@$(call add,NET_ETH,eth0:dhcp)
	@$(call add,NET_ETH,eth1:dhcp)
	@$(call add,NET_ETH,eth2:dhcp)
	@$(call add,THE_PACKAGES,fbset-modes-sm750-bfk3)

use/mipsel-bfk3/x11: use/mipsel-bfk3 use/x11/radeon; @:
