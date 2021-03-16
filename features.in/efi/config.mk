EFI_ARCHES := x86_64 aarch64 riscv64

+efi: use/efi/signed; @:

ifeq (,$(filter-out $(EFI_ARCHES),$(ARCH)))

EFI_LISTS := $(call tags,base efi)

use/efi:
	@$(call add_feature)
	@$(call set,MKI_VER_MINIMAL,0.2.12)	# it's official now
	@$(call set,MKI_VER_OPTIMAL,0.2.17)	# for EFI_BOOTARGS
	@$(call try,EFI_BOOTLOADER,grub-efi)	# default one
	@$(call xport,EFI_BOOTLOADER)
	@$(call add,THE_LISTS,$(EFI_LISTS))
ifeq (distro,$(IMAGE_CLASS))
	@$(call add,RESCUE_LISTS,$(EFI_LISTS))
	@$(call add,INSTALL2_PACKAGES,dosfstools fatresize)
	@$(call add,STAGE1_KCONFIG,EFI EFI_PARTITION FB_EFI EFIVAR_FS)
	@$(call add,EFI_BOOTARGS,$$(STAGE2_BOOTARGS))
ifeq (x86_64,$(ARCH))
	@$(call add,RESCUE_PACKAGES,refind $$(EFI_SHELL) $$(EFI_BOOTLOADER))
	@$(call add,THE_PACKAGES,$$(EFI_SHELL))
endif
endif

use/efi/grub: use/efi use/bootloader/grub
	@$(call set,EFI_BOOTLOADER,grub-efi)

ifeq (x86_64,$(ARCH))
use/efi/shell: use/efi
	@$(call try,EFI_SHELL,efi-shell)

use/efi/signed: use/efi
	@$(call set,EFI_CERT,altlinux)
	@$(call add,COMMON_PACKAGES,shim-signed)
	@$(call add,RESCUE_PACKAGES,openssl pesign)

use/efi/lilo: use/efi use/bootloader/lilo
	@$(call set,EFI_BOOTLOADER,elilo)

use/efi/refind: use/efi
	@$(call set,EFI_BOOTLOADER,refind)

use/efi/memtest86: use/efi
	@$(call set,EFI_MEMTEST86,efi-memtest86)

else

use/efi/signed use/efi/shell \
	use/efi/refind use/efi/memtest86 use/efi/lilo: use/efi; @:

endif

ifeq (distro,$(IMAGE_CLASS))
use/efi/debug: use/efi
	@$(call add,STAGE2_PACKAGES,efibootmgr gdisk)
else
use/efi/debug: use/efi; @:
endif

else

# ignore on an unsupported target arch but make it hybrid at least
use/efi use/efi/signed use/efi/debug use/efi/grub use/efi/lilo \
  use/efi/refind use/efi/shell use/efi/memtest86: use/isohybrid; @:

endif
