# TODO: invent something prettier (think "lilo+grub" -- or error out?)
# - add,BASE_PACKAGES,alterator-$* is overly additive
#   NB: due to make target becoming having been made,
#       the last different one wins
# - remember .base if adding yet another *_PACKAGES

use/bootloader:
	@$(call add_feature)
	@$(call add,BASE_PACKAGES,alterator-$$(BASE_BOOTLOADER))

use/bootloader/grub use/bootloader/lilo: use/bootloader/%: use/bootloader
	@$(call set,BASE_BOOTLOADER,$*)
