+nm: use/net/nm/nodelay; @:

use/net: use/services
	@$(call add_feature)
	@$(call add,THE_PACKAGES,etcnet)
	@$(call add,DEFAULT_SERVICES_ENABLE,network)

use/net/dhcp: use/net
	@$(call add,THE_PACKAGES,dhcpcd)

# base service, no GUI
use/net/nm: use/net
	@$(call add,THE_LISTS,$(call tags,base nm))
	@$(call add,LIVE_PACKAGES,livecd-save-nfs)
	@$(call add,DEFAULT_SERVICES_ENABLE,NetworkManager ModemManager)
	@$(call add,DEFAULT_SERVICES_ENABLE,livecd-save-nfs) # keep interface up

use/net/nm/nodelay: use/net/nm
	@$(call add,DEFAULT_SERVICES_DISABLE,NetworkManager-wait-online)

use/net/connman: use/net
	@$(call add,THE_PACKAGES,connman)
	@$(call add,DEFAULT_SERVICES_ENABLE,connmand)
