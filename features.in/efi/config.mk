ifeq (x86_64,$(ARCH))

EFI_LISTS := $(call tags,base efi)

use/efi:
	@$(call add_feature)
	@$(call set,MKI_VER_MINIMAL,0.2.5)	# see #28219
	@$(call add,THE_LISTS,$(EFI_LISTS))
	@$(call add,RESCUE_LISTS,$(EFI_LISTS))
	@$(call add,RESCUE_PACKAGES,refind)
	@$(call add,INSTALL2_PACKAGES,dosfstools)
	@$(call try,EFI_BOOTLOADER,elilo)	# default one

use/efi/refind: use/efi
	@$(call set,EFI_BOOTLOADER,refind)

use/efi/signed: use/efi
	@$(call set,EFI_CERT,altlinux)

use/efi/debug: use/efi
	@$(call add,STAGE2_PACKAGES,efibootmgr gdisk)
	@$(call set,KFLAVOURS,led-ws)

else

# ignore on an unsupported target arch but make it hybrid at least
use/efi use/efi/refind use/efi/signed use/efi/debug: use/isohybrid

endif
