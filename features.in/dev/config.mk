use/dev:
	@$(call add_feature)
	@$(call add,COMMON_PACKAGES,git-core hasher gear)

use/dev/mkimage: use/dev
	@$(call add,COMMON_PACKAGES,mkimage)
	@$(call add,LIVE_PACKAGES,shadow-change)
