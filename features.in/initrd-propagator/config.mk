use/initrd-propagator:
	@$(call add_feature)
	@$(call add,STAGE1_PACKAGES,make-initrd-propagator propagator)
	@$(call set,STAGE1_INITRD,initrd-propagator)
