# "1" is not a typo
use/stage2: sub/stage1
	@$(call add_feature)
	@$(call add,STAGE1_PACKAGES,file make-initrd make-initrd-propagator propagator)

use/stage2/kms:
	@$(call add,STAGE1_KMODULES_REGEXP,drm.*)

# NB: sub/stage2 isn't used standalone but rather
#     as a base for various livecd modifications
#     (currently install2, live, rescue)
