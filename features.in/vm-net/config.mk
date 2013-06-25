use/vm-net:
	@$(warning obsolete feature, please upgrade to use/net-eth)

use/vm-net/dhcp: use/vm-net use/net-eth/dhcp

# need to further add VM_NET_IPV4ADDR and VM_NET_IPV4GW
use/vm-net/static: use/vm-net use/net-eth
	@$(call add,NET_ETH,eth0:static:$(VM_NET_IPV4ADDR):$(VM_NET_IPV4GW))
