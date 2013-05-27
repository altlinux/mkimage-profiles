use/fonts:
	@$(call add_feature)
	@$(call xport,FONT_FEATURES_ENABLE)
	@$(call xport,FONT_FEATURES_DISABLE)

# just stating that kernels and font habits are pretty individual
use/fonts/zerg: use/fonts
	@$(call set,FONT_FEATURES_ENABLE,antialias lcdfilter-default \
		hinting style-full sub-pixel-rgb)
	@$(call set,FONT_FEATURES_DISABLE,no-antialias lcdfilter-none \
		unhinted no-sub-pixel)

# nothing configured to add_feature but let's not skip that for consistency
use/fonts/infinality: use/fonts
	@$(call add,THE_PACKAGES,libfreetype-infinality fontconfig-infinality)
