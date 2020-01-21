ifeq (,$(filter-out aarch64,$(ARCH)))
use/aarch64-dbm: use/efi/grub use/tty/S0
	@$(call add_feature)
	@$(call set,KFLAVOURS,bfkm)
	@$(call add,BASE_BOOTARGS,video=HDMI-A-1:D fbcon=map:0)
endif
