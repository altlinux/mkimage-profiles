# fontconfig setup
use/fonts:
	@$(call add_feature)
	@$(call try,FONTS,fonts-ttf-google-croscore-arimo)
	@$(call add,THE_PACKAGES,$$(FONTS))
	@$(call xport,FONT_FEATURES_ENABLE)
	@$(call xport,FONT_FEATURES_DISABLE)

# standalone target to specify non-bitmap installer fonts
use/fonts/install2 use/fonts/system:
	@$(call try,SYSTEM_FONTS,fonts-ttf-google-croscore-arimo)
	@$(call add,SYSTEM_PACKAGES,$$(SYSTEM_FONTS))

# just stating that kernels and font habits are pretty individual
use/fonts/zerg: use/fonts
	@$(call set,FONT_FEATURES_ENABLE,antialias lcdfilter-default \
		hinting style-full sub-pixel-rgb)
	@$(call set,FONT_FEATURES_DISABLE,no-antialias lcdfilter-none \
		unhinted no-sub-pixel)

# nothing configured to add_feature but let's not skip that for consistency
use/fonts/infinality: use/fonts
	@$(call add,THE_PACKAGES,libfreetype-infinality fontconfig-infinality)

# #34142
use/fonts/chinese: use/fonts
	@$(call add,FONTS,fonts-bitmap-wqy)

# a few typical font collections
# NB: dejavu is ugly thus missing
# NB: not depending on use/fonts intentionally,
#     the scripts are unneeded to add packages
use/fonts/otf/adobe: use/fonts
	@$(call add,FONTS,fonts-otf-adobe-source-code-pro)
	@$(call add,FONTS,fonts-otf-adobe-source-sans-pro)

use/fonts/otf/mozilla: use/fonts
	@$(call add,FONTS,fonts-otf-mozilla-fira)

use/fonts/ttf/google: use/fonts
	@$(call add,FONTS,fonts-ttf-google-droid-sans)
	@$(call add,FONTS,fonts-ttf-google-droid-sans-mono)
	@$(call add,FONTS,fonts-ttf-google-droid-serif)
	@$(call add,FONTS,fonts-ttf-google-croscore-arimo)
	@$(call add,FONTS,fonts-ttf-google-croscore-cousine)
	@$(call add,FONTS,fonts-ttf-google-croscore-tinos)

use/fonts/ttf/google/extra: use/fonts/ttf/google
	@$(call add,FONTS,fonts-ttf-google-crosextra-caladea)
	@$(call add,FONTS,fonts-ttf-google-crosextra-carlito)

use/fonts/ttf/redhat: use/fonts
	@$(call add,FONTS,fonts-ttf-liberation)

use/fonts/ttf/ubuntu: use/fonts
	@$(call add,FONTS,fonts-ttf-ubuntu-font-family)

use/fonts/ttf/xo: use/fonts
	@$(call add,FONTS,fonts-ttf-XO)
	@$(call add,FONTS,fonts-ttf-PT)
	@$(call add,FONTS,fonts-ttf-Cormorant)
	@$(call add,FONTS,fonts-ttf-open-sans)
