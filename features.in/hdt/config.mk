# optimized out use/syslinux due to use/memtest
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
use/hdt: use/memtest
	@$(call add_feature)
	@$(call add,STAGE1_PACKAGES,pciids)
	@$(call add,SYSLINUX_MODULES,hdt)
else
use/hdt: ; @:
endif
