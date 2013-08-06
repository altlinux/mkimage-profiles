use/control:
	@$(call add_feature)
	@$(call add,THE_PACKAGES,control)
	@$(call xport,CONTROL)

# some presets
use/control/sudo-su: use/control
	@$(call add,CONTROL,su:public sudo:public)
