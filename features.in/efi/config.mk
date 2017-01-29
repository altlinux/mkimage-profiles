+efi: use/efi/signed; @:

ifeq (x86_64,$(ARCH))

EFI_LISTS := $(call tags,base efi)

use/efi:
	@$(call add_feature)
	@$(call set,MKI_VER_MINIMAL,0.2.12)	# it's official now
	@$(call add,THE_LISTS,$(EFI_LISTS))
	@$(call add,RESCUE_LISTS,$(EFI_LISTS))
	@$(call add,THE_PACKAGES,$$(EFI_SHELL))
	@$(call add,RESCUE_PACKAGES,refind $$(EFI_SHELL))
	@$(call add,INSTALL2_PACKAGES,dosfstools fatresize)
	@$(call try,EFI_BOOTLOADER,elilo)	# default one
	@$(call add,STAGE1_KCONFIG,EFI EFI_PARTITION EFI_VARS FB_EFI)
	@$(call set,MKI_VER_OPTIMAL,0.2.17)	# for EFI_BOOTARGS
	@$(call add,EFI_BOOTARGS,$$(STAGE2_BOOTARGS))

use/efi/refind: use/efi
	@$(call set,EFI_BOOTLOADER,refind)

use/efi/signed: use/efi
	@$(call set,EFI_CERT,altlinux)
	@$(call add,COMMON_PACKAGES,shim-signed)
	@$(call add,RESCUE_PACKAGES,openssl pesign sbsigntools)

use/efi/shell: use/efi
	@$(call try,EFI_SHELL,efi-shell)

use/efi/memtest86: use/efi/refind
	@$(call set,EFI_MEMTEST86,efi-memtest86)

use/efi/debug: use/efi
	@$(call add,STAGE2_PACKAGES,efibootmgr gdisk)

else

# ignore on an unsupported target arch but make it hybrid at least
use/efi use/efi/signed use/efi/debug \
  use/efi/refind use/efi/shell use/efi/memtest86: use/isohybrid; @:

endif
