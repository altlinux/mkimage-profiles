# TODO: invent something prettier (think "lilo+grub" -- or error out?)
# - add,BASE_PACKAGES,alterator-$* is overly additive
#   NB: due to make target becoming having been made,
#       the last different one wins
# - remember .base if adding yet another *_PACKAGES

# NB: "mysterious" conflicts if BASE_BOOTLOADER is empty

GRUB_ARCHES := i586 x86_64 aarch64 ppc64le

use/bootloader: use/pkgpriorities
	@$(call add_feature)
	@$(call try,BASE_BOOTLOADER,grub)
	@$(call xport,BASE_BOOTLOADER)
	@$(call add,BASE_LISTS,$$(BASE_BOOTLOADER))
ifeq (distro,$(IMAGE_CLASS))
	@$(call add,BASE_PACKAGES,alterator-$$(BASE_BOOTLOADER))
	@$(call add,PINNED_PACKAGES,alterator-$$(BASE_BOOTLOADER))
	@$(call add,PINNED_PACKAGES,installer-bootloader-$$(BASE_BOOTLOADER)-stage2)
endif

ifeq (,$(filter-out i586 x86_64,$(ARCH)))
use/bootloader/lilo: \
	use/bootloader/%: use/bootloader
	@$(call set,BASE_BOOTLOADER,$*)
endif

ifeq (,$(filter-out $(GRUB_ARCHES),$(ARCH)))
use/bootloader/grub: \
	use/bootloader/%: use/bootloader
	@$(call set,BASE_BOOTLOADER,$*)
endif

use/bootloader/uboot: use/bootloader use/uboot
	@$(call set,BASE_BOOTLOADER,uboot)

use/bootloader/live: use/bootloader
	@$(call add,LIVE_PACKAGES,alterator-$$(BASE_BOOTLOADER))

use/bootloader/os-prober: use/bootloader
	@$(call add,BASE_PACKAGES,os-prober)
