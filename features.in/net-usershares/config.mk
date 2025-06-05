# requires thunar-shares-plugin or mate-user-share to make sense
use/net-usershares: use/control use/services \
	@$(call add,CONTROL,libnss-role:enabled)
	@$(call add,CONTROL,role-usershares:enabled)
	@$(call add,CONTROL,smb-conf-usershares:enabled)
	@$(call add,SYSTEMD_SERVICES_ENABLE,nmb.service)
	@$(call add,SYSTEMD_SERVICES_ENABLE,smb.service)
	@$(call add,THE_PACKAGES,alterator-roles-common)
	@$(call add,THE_PACKAGES,libnss-role)
	@$(call add,THE_PACKAGES,samba-usershares)
