use/domain-client: use/net/dhcp
	@$(call add_feature)
	@$(call add,THE_LISTS,domain-client)

use/domain-client/full: use/domain-client
	@$(call add,DEFAULT_SERVICES_ENABLE,avahi-daemon)
	@$(call add,BASE_LISTS,domain-client-i) # i-f-* shouldn't hit live
