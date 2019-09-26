
ifeq (,$(filter-out aarch64,$(ARCH)))
use/aarch64-tegra: use/bootloader/uboot
	@$(call add_feature)
	@$(call set,KFLAVOURS,tegra)
endif
