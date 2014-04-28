use/net-eth: use/net
	@$(call add_feature)
	@$(call xport,NET_ETH)
	@$(call add,BASE_PACKAGES,udev-rule-generator-net)

# see also use/stage2/net-eth

# typical boilerplate
use/net-eth/dhcp: use/net-eth use/net/dhcp
	@$(call add,NET_ETH,eth0:dhcp)

# use e.g. eth0:static:10.0.0.2/24:10.0.0.1 for predefined static configuration
