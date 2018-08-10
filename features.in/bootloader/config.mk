# TODO: invent something prettier (think "lilo+grub" -- or error out?)
# - add,BASE_PACKAGES,alterator-$* is overly additive
#   NB: due to make target becoming having been made,
#       the last different one wins
# - remember .base if adding yet another *_PACKAGES

# NB: "mysterious" conflicts if BASE_BOOTLOADER is empty

use/bootloader: use/pkgpriorities
	@$(call add_feature)
	@$(call add,BASE_PACKAGES,alterator-$$(BASE_BOOTLOADER))
	@$(call add,PINNED_PACKAGES,alterator-$$(BASE_BOOTLOADER))
	@$(call add,PINNED_PACKAGES,installer-bootloader-$$(BASE_BOOTLOADER)-stage2)

use/bootloader/grub use/bootloader/lilo: use/bootloader/%: use/bootloader
	@$(call set,BASE_BOOTLOADER,$*)

use/bootloader/live: use/bootloader
	@$(call add,LIVE_PACKAGES,alterator-$$(BASE_BOOTLOADER))

use/bootloader/os-prober: use/bootloader
ifeq (,$(filter-out i586 x86_64 aarch64,$(ARCH)))
	@$(call add,BASE_PACKAGES,os-prober)
endif
