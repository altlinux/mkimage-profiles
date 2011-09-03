# common
use/powerbutton:
	@$(call add,COMMON_PACKAGES,installer-feature-powerbutton-stage3)

# modern power management
use/powerbutton/acpi: use/powerbutton
	@$(call add,COMMON_PACKAGES,acpid acpid-events-power)

use/powerbutton/powersave: use/powerbutton/acpi
	@$(call add,COMMON_PACKAGES,powersave)

# legacy power management
use/powerbutton/apm: use/powerbutton
	@$(call add,COMMON_PACKAGES,apmd)
