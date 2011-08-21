# TODO: invent something prettier (think "lilo+grub" -- or error out?)
# - add,BASE_PACKAGES,alterator-$* is overly additive
# - remember .base if adding yet another *_PACKAGES

use/bootloader: use/install2 sub/main
	@$(call add,BASE_PACKAGES,alterator-$$(GLOBAL_BASE_BOOTLOADER))

use/bootloader/grub use/bootloader/lilo: use/bootloader/%: use/bootloader
	@$(call set,GLOBAL_BASE_BOOTLOADER,$*)
