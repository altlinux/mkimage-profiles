use/efi:
	@$(call add,THE_LISTS,$(call tags,base efi))
	@$(call add,INSTALL2_PACKAGES,dosfstools)

use/efi/debug: use/efi
	@$(call add,STAGE2_PACKAGES,efibootmgr gdisk)
	@$(call set,KFLAVOURS,led-ws)	### CONFIG_FB_EFI
