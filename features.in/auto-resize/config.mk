use/auto-resize:
	@$(call add_feature)
	@$(call add,BASE_PACKAGES,make-initrd-kickstart)
	@$(call add,BASE_PACKAGES,f2fs-tools xfsprogs)
	@$(call add,VM_INITRDFEATURES,kickstart)
