use/control:
	@$(call add_feature)
	@$(call add,THE_PACKAGES,control)
	@$(call xport,CONTROL)

# some presets
use/control/sudo-su:
	@$(call add,CONTROL,su:public sudo:public)
