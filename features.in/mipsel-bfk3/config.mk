use/mipsel-bfk3: use/kernel
	@$(call add_feature)
	@$(call set,KFLAVOURS,bfk3-def)
	@$(call set,VM_FSTYPE,ext2)
	@$(call add,NET_ETH,eth0:dhcp)
	@$(call add,NET_ETH,eth1:dhcp)
	@$(call add,NET_ETH,eth2:dhcp)
