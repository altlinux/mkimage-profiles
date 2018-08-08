use/volumes:
	@$(call add_feature)
	@$(call add,INSTALL2_PACKAGES,$$(STAGE2_VOLUMES_PROFILE))
	@$(call add,LIVE_PACKAGES,$$(STAGE2_VOLUMES_PROFILE))

use/volumes/%: use/volumes
	@$(call set,STAGE2_VOLUMES_PROFILE,volumes-profile-$*)
