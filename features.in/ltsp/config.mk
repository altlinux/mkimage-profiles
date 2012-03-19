+ltsp: use/ltsp/base; @:

use/ltsp:
	@$(call add,INSTALL2_PACKAGES,installer-feature-ltsp-stage2)
	@$(call add,MAIN_LISTS,ltsp-client ltsp-client.$(ARCH))
	@$(call add,BASE_LISTS,ltsp)

use/ltsp/base: use/ltsp use/firmware
	@$(call add,BASE_LISTS,$(call tags,base network))
	@$(call add,BASE_PACKAGES,apt-repo firefox)
