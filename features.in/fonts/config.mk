# fontconfig setup
use/fonts:
	@$(call add_feature)
	@$(call xport,FONT_FEATURES_ENABLE)
	@$(call xport,FONT_FEATURES_DISABLE)

# standalone target to specify non-bitmap installer fonts
use/fonts/install2:
	@$(call add,SYSTEM_PACKAGES,fonts-ttf-google-croscore-arimo)

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
	@$(call add,THE_PACKAGES,fonts-bitmap-wqy)

# a few typical font collections
# NB: dejavu is ugly thus missing
# NB: not depending on use/fonts intentionally,
#     the scripts are unneeded to add packages
use/fonts/otf/adobe:
	@$(call add,THE_PACKAGES,fonts-otf-adobe-source-code-pro)
	@$(call add,THE_PACKAGES,fonts-otf-adobe-source-sans-pro)

use/fonts/otf/mozilla:
	@$(call add,THE_PACKAGES,fonts-otf-mozilla-fira)

use/fonts/ttf/google:
	@$(call add,THE_PACKAGES,fonts-ttf-google-droid-sans)
	@$(call add,THE_PACKAGES,fonts-ttf-google-droid-sans-mono)
	@$(call add,THE_PACKAGES,fonts-ttf-google-droid-serif)
	@$(call add,THE_PACKAGES,fonts-ttf-google-croscore-arimo)
	@$(call add,THE_PACKAGES,fonts-ttf-google-croscore-cousine)
	@$(call add,THE_PACKAGES,fonts-ttf-google-croscore-tinos)

use/fonts/ttf/google/extra: use/fonts/ttf/google
	@$(call add,THE_PACKAGES,fonts-ttf-google-crosextra-caladea)
	@$(call add,THE_PACKAGES,fonts-ttf-google-crosextra-carlito)

use/fonts/ttf/redhat:
	@$(call add,THE_PACKAGES,fonts-ttf-liberation)

use/fonts/ttf/ubuntu:
	@$(call add,THE_PACKAGES,fonts-ttf-ubuntu-font-family)
