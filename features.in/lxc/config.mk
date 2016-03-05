use/lxc:
	@$(call add_feature)
	@$(call add,CONTROL,fusermount:public)
	@$(call add,GROUPS,tun)

use/lxc/lxd: use/lxc
	@$(call add,GROUPS,netadmin lxd)
	@$(call add,LIVE_LISTS,lxd)
	@$(call add,LIVE_LISTS,openssh)
	@$(call add,LIVE_PACKAGES,livecd-net-eth)
	@$(call add,LIVE_PACKAGES,udev-rule-generator-net)
