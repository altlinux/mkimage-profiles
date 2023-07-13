use/services: sub/rootfs
	@$(call add_feature)
	@$(call xport,DEFAULT_SERVICES_ENABLE)
	@$(call xport,DEFAULT_SERVICES_DISABLE)
	@$(call xport,SERVICES_ENABLE)
	@$(call xport,SERVICES_DISABLE)
	@$(call xport,DEFAULT_SYSTEMD_SERVICES_ENABLE)
	@$(call xport,DEFAULT_SYSTEMD_SERVICES_DISABLE)
	@$(call xport,SYSTEMD_SERVICES_ENABLE)
	@$(call xport,SYSTEMD_SERVICES_DISABLE)
	@$(call xport,DEFAULT_SYSTEMD_USER_SERVICES_ENABLE)
	@$(call xport,DEFAULT_SYSTEMD_USER_SERVICES_DISABLE)
	@$(call xport,SYSTEMD_USER_SERVICES_ENABLE)
	@$(call xport,SYSTEMD_USER_SERVICES_DISABLE)

user/services/dbus-brocker: use/services
	@$(call add,DEFAULT_SERVICES_ENABLE,bluetoothd dbus-broker)
	@$(call add,DEFAULT_SYSTEMD_USER_SERVICES_ENABLE,dbus-broker)

use/services/lvm2-disable: use/services
	@$(call add,DEFAULT_SERVICES_DISABLE,lvm2-lvmetad)
	@$(call add,DEFAULT_SERVICES_DISABLE,lvm2-lvmpolld)
	@$(call add,DEFAULT_SERVICES_DISABLE,lvm2-monitor)
