# Input Method configuration through IBus

use/im: use/l10n
	@$(call add_feature)
	@$(call add,THE_PACKAGES,$$(IM_PACKAGES))
	@$(call add,THE_LISTS,$(call tags,desktop ibus))
