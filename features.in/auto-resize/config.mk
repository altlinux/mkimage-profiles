use/auto-resize:
	@$(call add_feature)
	@$(call add,BASE_BOOTARGS,ksfile=ks.cfg)
	@$(call add,BASE_PACKAGES,make-initrd-kickstart)
	@$(call add,VM_INITRDFEATURES,kickstart)
