# NB: this is aimed at LiveCD/installer images
+net-eth: use/net-eth use/stage2/net-eth; @:

# see also use/stage2/net-eth; do not depend on it though
# as stage2-less images need preconfigured networking too
use/net-eth: use/net/etcnet
	@$(call add_feature)
	@$(call xport,NET_ETH)
	@$(call add,BASE_PACKAGES,udev-rule-generator-net)

use/net-eth/networkd: use/net/networkd
	@$(call add_feature)
	@$(call xport,NET_ETH)
	@$(call add,BASE_PACKAGES,udev-rule-generator-net)

# typical boilerplate
use/net-eth/dhcp: use/net-eth use/net/dhcp
	@$(call add,NET_ETH,eth0:dhcp)

use/net-eth/networkd-dhcp: use/net-eth/networkd
	@$(call add,NET_ETH,eth0:dhcp)

# use e.g. eth0:static:10.0.0.2/24:10.0.0.1 for predefined static configuration
