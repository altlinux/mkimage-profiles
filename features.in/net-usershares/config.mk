# requires thunar-shares-plugin or mate-user-share to make sense
use/net-usershares: use/services use/deflogin
	@$(call add,GROUPS,sambashare)
	@$(call add,DEFAULT_SERVICES_ENABLE,smb nmb)
	@$(call add,THE_PACKAGES,libshell)
