+nm: use/net/nm; @:
+nm-native: use/net/nm/native; @:

use/net: use/services use/pkgpriorities
	@$(call add_feature)
	@$(call add,THE_PACKAGES,$$(THE_NET_SUBSYS))
	@$(call add,PINNED_PACKAGES,$$(THE_NET_SUBSYS))
	@$(call set,THE_NET_SUBSYS,network-config-subsystem)

use/net/etcnet: use/net
	@$(call set,THE_NET_SUBSYS,etcnet)
	@$(call add,DEFAULT_SERVICES_ENABLE,network)

use/net/dhcp: use/net
	@$(call add,THE_PACKAGES,dhcpcd)

# base service, no GUI; see x11 feature for those
use/net/nm: use/net
	@$(call set,THE_NET_SUBSYS,NetworkManager)
	@$(call add,THE_LISTS,$(call tags,base nm))  # NB: won't get overridden
	@$(call add,LIVE_PACKAGES,livecd-save-nfs)
	@$(call add,DEFAULT_SERVICES_ENABLE,network) # need for NM?
	@$(call add,DEFAULT_SERVICES_ENABLE,NetworkManager ModemManager)
	@$(call add,DEFAULT_SERVICES_ENABLE,livecd-save-nfs) # keep interface up
	@$(call xport,NM_native)

# use NetworkManager(native)
use/net/nm/native: use/net/nm
	@$(call set,NM_Native,yes)

# NOT recommended unless you know what you're doing
# (e.g. dnsmasq can win a race against dhcpcd)
use/net/nm/nodelay: use/net/nm
	@$(call add,DEFAULT_SERVICES_DISABLE,NetworkManager-wait-online)

use/net/nm/mmgui: use/net/nm
	@$(call set,THE_NET_SUBSYS,modem-manager-gui)

use/net/connman: use/net
	@$(call set,THE_NET_SUBSYS,connman)
	@$(call add,DEFAULT_SERVICES_ENABLE,connmand connman)

use/net/networkd: use/net
	@$(call set,THE_NET_SUBSYS,systemd-networkd)
	@$(call add,DEFAULT_SERVICES_ENABLE,systemd-networkd)
