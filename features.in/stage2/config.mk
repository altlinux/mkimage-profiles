# "1" is not a typo
use/stage2: sub/stage1
	@$(call add_feature)
	@$(call add,STAGE1_PACKAGES,file make-initrd make-initrd-propagator propagator)

use/stage2/kms:
	@$(call add,STAGE1_KMODULES_REGEXP,drm.*)

# eth0 instead of enp0s3
use/stage2/net-eth: use/stage2
	@$(call add,STAGE1_PACKAGES,udev-rule-generator-net)
	@$(call add,STAGE2_PACKAGES,udev-rule-generator-net livecd-net-eth)

# NB: sub/stage2 isn't used standalone but rather
#     as a base for various livecd modifications
#     (currently install2, live, rescue)
