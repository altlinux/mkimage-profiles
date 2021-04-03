ifeq (,$(filter-out i586 x86_64 aarch64,$(ARCH)))
UUID_ISO = $(shell date -u +%Y-%m-%d-%H-%M-%S-00)
UUID_ISO_SHRT = $(shell echo $(UUID_ISO) | sed 's/-//g')

use/uuid-iso:
	@$(call add_feature)
	@$(call set,MKI_VER_MINIMAL,0.2.41)
	@$(call set,UUID_ISO_SHRT,$(UUID_ISO_SHRT))
	@$(call set,UUID_ISO,$(UUID_ISO))
	@$(call xport,UUID_ISO)

else
use/uuid-iso: ; @:
endif
