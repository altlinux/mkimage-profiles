use/mipsel-mitx: use/kernel use/tty/S0 use/net-eth/dhcp/timeout/20
	@$(call add_feature)
	@$(call set,KFLAVOURS,mitx-xpa)
	@$(call add,THE_PACKAGES,alt-config-be-t)

use/mipsel-mitx/x11: use/mipsel-mitx
	@$(call add,THE_PACKAGES,xorg-conf-sm750-tavolga)
