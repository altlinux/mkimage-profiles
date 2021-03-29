use/initrd-bootchain: use/uuid-iso
	@$(call add_feature)
	@$(call set,STAGE1_INITRD,initrd-pipeline)
	@$(call set,STAGE1_PACKAGES,make-initrd-bootchain)
	@$(call set,STAGE1_INITRD_TYPEARGS,$(shell echo "root=bootchain bootchain=fg,altboot bc_debug automatic"))
	@$(call set,STAGE1_INITRD_BOOTMETHOD,$(shell echo "method:cdrom,uuid:$(UUID_ISO)"))
	@$(call set,STAGE1_INITRD_STAGE2_OPTION,stagename)
