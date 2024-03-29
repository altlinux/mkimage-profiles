use/xdg-user-dirs: use/control use/services
	@$(call add_feature)
	@$(call add,CONTROL,xdg-user-dirs:enabled)
	@$(call add,THE_PACKAGES,xdg-user-dirs)
	@$(call add,DEFAULT_SYSTEMD_USER_SERVICES_ENABLE,xdg-user-dirs)
	@$(call xport,XDG_USER_DIRS)

# tweak some values to move these dirs into Documents/
use/xdg-user-dirs/deep: use/xdg-user-dirs
	@$(call add,XDG_USER_DIRS,MOVIES:Documents/Videos)
	@$(call add,XDG_USER_DIRS,PHOTOS:Documents/Pictures)
