use/vm-net:
	@$(call add_feature)
	@$(call add,THE_PACKAGES,etcnet)

use/vm-net/dhcp: use/vm-net
	@$(call add,THE_PACKAGES,dhcpcd)
	@$(call set,VM_NET,dhcp)

# need to further add VM_NET_IPV4ADDR and VM_NET_IPV4GW
use/vm-net/static: use/vm-net
	@$(call set,VM_NET,static)
