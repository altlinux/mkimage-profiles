ifeq (,$(filter-out i586 x86_64,$(ARCH)))
use/memtest: use/syslinux
	@$(call add_feature)
	@$(call add,SYSTEM_PACKAGES,memtest86+)
	@$(call add,SYSLINUX_CFG,memtest)
else
use/memtest: ; @:
endif
# see also use/efi/memtest86
