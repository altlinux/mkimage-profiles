use/live: use/stage2 sub/stage2/live
	@$(call add,FEATURES,live)
	@$(call add,LIVE_LISTS,$(call tags,(base || desktop) && (live || network || icewm)))
