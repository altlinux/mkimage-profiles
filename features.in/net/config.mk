+nm: use/net/nm/nodelay; @:

use/net: use/services
	@$(call add_feature)
	@$(call add,THE_PACKAGES,network-config-subsystem)

use/net/etcnet: use/net
	@$(call add,THE_PACKAGES,etcnet)
	@$(call add,DEFAULT_SERVICES_ENABLE,network)

use/net/dhcp: use/net
	@$(call add,THE_PACKAGES,dhcpcd)

# base service, no GUI
use/net/nm: use/net
	@$(call add,THE_LISTS,$(call tags,base nm))
	@$(call add,LIVE_PACKAGES,livecd-save-nfs)
	@$(call add,DEFAULT_SERVICES_ENABLE,network) #  need for NM?
	@$(call add,DEFAULT_SERVICES_ENABLE,NetworkManager ModemManager)
	@$(call add,DEFAULT_SERVICES_ENABLE,livecd-save-nfs) # keep interface up

use/net/nm/nodelay: use/net/nm
	@$(call add,DEFAULT_SERVICES_DISABLE,NetworkManager-wait-online)

use/net/nm/mmgui: use/net/nm
	@$(call add,THE_PACKAGES,modem-manager-gui)

use/net/connman: use/net
	@$(call add,THE_PACKAGES,connman)
	@$(call add,DEFAULT_SERVICES_ENABLE,connmand connman)

use/net/networkd: use/net
	@$(call add,THE_PACKAGES,systemd-networkd)
	@$(call add,DEFAULT_SERVICES_ENABLE,systemd-networkd)
