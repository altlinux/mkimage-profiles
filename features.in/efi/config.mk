use/efi:
	@$(call add_feature)
	@$(call set,MKI_VER_MINIMAL,0.2.5)	# see #28219
	@$(call add,THE_LISTS,$(call tags,base efi))
	@$(call add,INSTALL2_PACKAGES,dosfstools)
	@$(call set,EFI_BOOTLOADER,elilo)	### no choice right now

use/efi/debug: use/efi
	@$(call add,STAGE2_PACKAGES,efibootmgr gdisk)
	@$(call set,KFLAVOURS,led-ws)
