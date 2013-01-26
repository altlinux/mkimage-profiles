+power: use/power/acpi/button use/power/acpi/cpufreq; @:

# common
# TODO: invent multi-target scripts and integrate that 08-powerbutton
use/power:
	@$(call add_feature)
	@$(call add,COMMON_PACKAGES,installer-feature-powerbutton-stage3)

# modern power management
use/power/acpi: use/power
	@$(call add,COMMON_PACKAGES,acpid acpi)

use/power/acpi/button: use/power/acpi
	@$(call add,COMMON_PACKAGES,acpid-events-power)

use/power/acpi/cpufreq: use/power/acpi
	@$(call add,COMMON_PACKAGES,installer-feature-cpufreq-stage3)

use/power/acpi/powersave: use/power/acpi
	@$(call add,COMMON_PACKAGES,powersave)

# legacy power management
use/power/apm: use/power
	@$(call add,COMMON_PACKAGES,apmd lphdisk)
