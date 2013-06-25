+nm: use/net/nm; @:

use/net: use/services
	@$(call add_feature)
	@$(call add,THE_PACKAGES,etcnet)
	@$(call add,DEFAULT_SERVICES_ENABLE,network)

use/net/dhcp: use/net
	@$(call add,THE_PACKAGES,dhcpcd)

use/net/nm: use/net
	@$(call add,THE_LISTS,$(call tags,desktop nm))
	@$(call add,DEFAULT_SERVICES_ENABLE,NetworkManager ModemManager)

use/net/connman: use/net
	@$(call add,THE_PACKAGES,connman)
	@$(call add,DEFAULT_SERVICES_ENABLE,connman)
