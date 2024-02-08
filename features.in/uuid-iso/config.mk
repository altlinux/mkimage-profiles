UUID_ISO := $(shell date -u +%Y-%m-%d-%H-%M-%S-00)
UUID_ISO_SHRT := $(shell echo $(UUID_ISO) | sed 's/-//g')

use/uuid-iso:
	@$(call add_feature)
	@$(call set,UUID_ISO_SHRT,$(UUID_ISO_SHRT))
	@$(call set,UUID_ISO,$(UUID_ISO))
	@$(call xport,UUID_ISO)
