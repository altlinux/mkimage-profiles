use/apt-conf:
	@$(call add_feature)
	@$(call add,THE_PACKAGES,apt-conf-$$(THE_APT_CONF))
	@$(call add,IMAGE_INIT_LIST,apt-conf-$$(THE_APT_CONF))
	@$(call try,THE_APT_CONF,sisyphus)

use/apt-conf/branch: use/apt-conf
	@$(call set,THE_APT_CONF,branch)
