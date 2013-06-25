use/services: sub/rootfs
	@$(call add_feature)
	@$(call xport,DEFAULT_SERVICES_ENABLE)
	@$(call xport,DEFAULT_SERVICES_DISABLE)
	@$(call xport,SERVICES_ENABLE)
	@$(call xport,SERVICES_DISABLE)

# some presets

use/services/ssh: use/services use/net
	@$(call add,THE_LISTS,openssh)
	@$(call add,DEFAULT_SERVICES_ENABLE,sshd)
