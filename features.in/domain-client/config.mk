use/domain-client: use/net/dhcp
	@$(call add_feature)
	@$(call add,THE_LISTS,domain-client)

use/domain-client/full: use/domain-client
	@$(call add,THE_PACKAGES,krb5-ticket-watcher)
	@$(call add,DEFAULT_SERVICES_ENABLE,avahi-daemon)
