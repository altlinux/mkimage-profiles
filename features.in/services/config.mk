use/services: sub/rootfs
	@$(call add_feature)
	@$(call xport,DEFAULT_SERVICES_ENABLE)
	@$(call xport,DEFAULT_SERVICES_DISABLE)
	@$(call xport,SERVICES_ENABLE)
	@$(call xport,SERVICES_DISABLE)
	@$(call xport,SYSTEMD_SERVICES_ENABLE)
	@$(call xport,SYSTEMD_SERVICES_DISABLE)

use/services/lvm2-disable: use/services
	@$(call add,DEFAULT_SERVICES_DISABLE,lvm2-lvmetad)
	@$(call add,DEFAULT_SERVICES_DISABLE,lvm2-lvmpolld)
	@$(call add,DEFAULT_SERVICES_DISABLE,lvm2-monitor)
