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
	@$(call xport,SYSTEMD_SERVICES_MASK)
	@$(call xport,SYSTEMD_SERVICES_UNMASK)
	@$(call xport,DEFAULT_SYSTEMD_USER_SERVICES_ENABLE)
	@$(call xport,DEFAULT_SYSTEMD_USER_SERVICES_DISABLE)
	@$(call xport,SYSTEMD_USER_SERVICES_ENABLE)
	@$(call xport,SYSTEMD_USER_SERVICES_DISABLE)

user/services/dbus-brocker: use/services
	@$(call add,DEFAULT_SERVICES_ENABLE,dbus-broker)
	@$(call add,DEFAULT_SYSTEMD_USER_SERVICES_ENABLE,dbus-broker)

use/services/lvm2-disable: use/services
	@$(call add,DEFAULT_SERVICES_DISABLE,lvm2-lvmetad)
	@$(call add,DEFAULT_SERVICES_DISABLE,lvm2-lvmpolld)
	@$(call add,DEFAULT_SERVICES_DISABLE,lvm2-monitor)

use/services/bluetooth-enable: use/services
	@$(call add,DEFAULT_SERICES_ENABLE,bluetooth)
	@$(call add,SYSTEMD_USER_SERVICES_ENABLE,obex.service)

use/services/bluetooth-disable: use/services
	@$(call add,DEFAULT_SERICES_DISABLE,bluetooth)
	@$(call add,SYSTEMD_USER_SERVICES_DISABLE,obex.service)
