# Input Method configuration through IBus

use/im:
	@$(call add_feature)
	@$(call add,THE_PACKAGES,$$(IM_PACKAGES))
	@$(call add,THE_LISTS,$(call tags,desktop ibus))
