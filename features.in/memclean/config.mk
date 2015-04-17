use/memclean: use/control
	@$(call add_feature)
	@$(call add,THE_PACKAGES,libzmalloc)
	@$(call add,CONTROL,libzmalloc:enabled)
