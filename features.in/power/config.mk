+power: use/power/acpi/button; @:

# common
use/power: sub/rootfs use/services
	@$(call add_feature)
	@$(call add,COMMON_PACKAGES,installer-feature-powerbutton-stage3)

# modern power management
use/power/acpi: use/power
	@$(call add,COMMON_PACKAGES,acpid acpi)
	@$(call add,DEFAULT_SERVICES_ENABLE,acpid)

use/power/acpi/button: use/power/acpi
	@$(call add,COMMON_PACKAGES,acpid-events-power)

use/power/acpi/powersave: use/power/acpi
	@$(call add,COMMON_PACKAGES,powersave)
	@$(call add,DEFAULT_SERVICES_DISABLE,acpid)	# override
	@$(call add,DEFAULT_SERVICES_ENABLE,powersaved)

# legacy power management
use/power/apm: use/power
	@$(call add,COMMON_PACKAGES,apmd lphdisk)
	@$(call add,DEFAULT_SERVICES_ENABLE,apmd)
