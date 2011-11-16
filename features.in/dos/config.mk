use/dos: use/syslinux
	@$(call add_feature)
	@$(call add,SYSLINUX_CFG,dos)
	@$(call add,SYSLINUX_FILES,/usr/lib/syslinux/memdisk)
	@$(call add,STAGE1_PACKAGES,make-freedos-floppy glibc-gconv-modules)
