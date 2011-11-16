use/live: use/stage2 sub/stage2/live
	@$(call add_feature)

use/live/base: use/live use/syslinux/ui-menu
	@$(call add,LIVE_LISTS,$(call tags,base && (live || network)))

use/live/icewm: use/live/base
	@$(call add,LIVE_LISTS,\
		$(call tags,(base || desktop) && (live || network || icewm)))
