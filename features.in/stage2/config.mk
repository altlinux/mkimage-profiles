# "1" is not a typo
use/stage2: sub/stage1
	@$(call add,FEATURES,stage2)
	@$(call add,STAGE1_PACKAGES,file make-initrd make-initrd-propagator)

# NB: sub/stage2 isn't used standalone but rather
#     as a base for various livecd modifications
#     (currently install2, live, rescue)
