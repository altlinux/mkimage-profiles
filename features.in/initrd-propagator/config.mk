use/initrd-propagator: use/uuid-iso
	@$(call add_feature)
	@$(call add,STAGE1_PACKAGES,make-initrd-propagator propagator)
	@$(call set,STAGE1_INITRD,initrd-propagator)
	@$(call set,STAGE1_INITRD_BOOTARGS,$(shell echo "changedisk automatic=method:cdrom,fuid:$(UUID_ISO)"))
	@$(call set,STAGE1_INITRD_STAGE2_OPTION,stagename)
