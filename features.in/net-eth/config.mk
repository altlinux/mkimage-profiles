use/net-eth: use/net/etcnet
	@$(call add_feature)
	@$(call xport,NET_ETH)
	@$(call add,BASE_PACKAGES,udev-rule-generator-net)

use/net-eth/networkd: use/net/networkd
	@$(call add_feature)
	@$(call xport,NET_ETH)

# typical boilerplate
use/net-eth/dhcp: use/net-eth use/net/dhcp
	@$(call add,NET_ETH,eth0:dhcp)
	@$(call try,NET_ETH_TIMEOUT,7)
	@$(call xport,NET_ETH_TIMEOUT)

use/net-eth/dhcp/timeout/%: use/net-eth/dhcp
	@$(call set,NET_ETH_TIMEOUT,$*)

use/net-eth/networkd-dhcp: use/net-eth/networkd
	@$(call set,NET_ETH,en*:dhcp eth*:dhcp)

use/net-eth/networkd-dhcp4: use/net-eth/networkd
	@$(call set,NET_ETH,en*:dhcp4 eth*:dhcp4)

# use e.g. eth0:static:10.0.0.2/24:10.0.0.1 for predefined static configuration
