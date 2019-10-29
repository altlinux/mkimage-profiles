
ifeq (,$(filter-out aarch64,$(ARCH)))
use/aarch64-dbm: use/efi/grub
	@$(call add_feature)
	@$(call set,KFLAVOURS,bfkm)
endif
