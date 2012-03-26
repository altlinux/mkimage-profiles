# tries to fill in ISO metadata in case it's the only inhabitant
use/dos: use/syslinux
	@$(call add_feature)
	@$(call add,SYSLINUX_CFG,dos)
	@$(call add,SYSLINUX_FILES,/usr/lib/syslinux/memdisk)
	@$(call add,STAGE1_PACKAGES,make-freedos-floppy glibc-gconv-modules)
	@$(call try,META_SYSTEM_ID,DOS)
	@$(call try,META_VOL_ID,FreeDOS 2.88M)
	@$(call try,META_VOL_SET,FreeDOS)
