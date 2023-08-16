use/initrd-propagator:
	@$(call add_feature)
	@$(call add,STAGE1_PACKAGES,make-initrd-propagator propagator)
	@$(call set,STAGE1_INITRD,initrd-propagator)
	@$(call set,STAGE1_INITRD_TYPEARGS,$(shell echo "changedisk automatic"))
	@$(call set,STAGE1_INITRD_BOOTMETHOD,$(shell echo "method:cdrom,fuid:$(UUID_ISO)"))
	@$(call set,STAGE1_INITRD_STAGE2_OPTION,stagename)
