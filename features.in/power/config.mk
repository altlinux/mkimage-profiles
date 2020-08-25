+power: use/power/acpi/button; @:

# common
use/power: sub/rootfs use/services
	@$(call add_feature)
ifeq (,$(filter-out e2k%,$(ARCH)))
	@$(call add,COMMON_PACKAGES,installer-feature-powerbutton-stage3)
endif

# modern power management
use/power/acpi: use/power
	@$(call add,COMMON_PACKAGES,acpid acpi)
	@$(call add,DEFAULT_SERVICES_ENABLE,acpid)

use/power/acpi/button: use/power/acpi
ifeq (,$(filter-out e2k%,$(ARCH)))
	@$(call add,COMMON_PACKAGES,acpid-events-e2k)
	@$(call add,INSTALL2_PACKAGES,installer-feature-e2k-power-stage2)
	@$(call add,DEFAULT_SERVICES_ENABLE,acpid sysfs)
else
	@$(call add,COMMON_PACKAGES,acpid-events-power)
endif

use/power/acpi/powersave: use/power/acpi
	@$(call add,COMMON_PACKAGES,powersave)
	@$(call add,DEFAULT_SERVICES_DISABLE,acpid)	# override
	@$(call add,DEFAULT_SERVICES_ENABLE,powersaved)

# legacy power management
use/power/apm: use/power
	@$(call add,COMMON_PACKAGES,apmd lphdisk)
	@$(call add,DEFAULT_SERVICES_ENABLE,apmd)
