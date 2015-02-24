+plymouth: use/plymouth/full; @:

# and a few aliases
use/plymouth/live: use/plymouth/stage2; @:
use/plymouth/install2: use/plymouth/stage2; @:

use/plymouth:
	@$(call add_feature)

# NB: *_REGEXP due to branding() using regexp and the
#     dependency resolution having to occur within a
#     single transaction (due to plymouth-system-theme)

# looks like there's no sense to pull in progressbars
# while leaving the very basic text bootloader screen
use/plymouth/stage2: use/plymouth use/branding \
	use/syslinux/ui/gfxboot use/stage2/kms
	@$(call add,STAGE1_PACKAGES_REGEXP,make-initrd-plymouth)
	@$(call add,STAGE1_BRANDING,bootsplash)
	@$(call add,STAGE2_BRANDING,bootsplash)
	@$(call add,STAGE2_BOOTARGS,quiet splash)

use/plymouth/base: use/plymouth/stage2
	@$(call add,INSTALL2_PACKAGES,installer-feature-setup-plymouth)
	@$(call add,BASE_PACKAGES_REGEXP,make-initrd-plymouth cpio)
	@$(call add,BASE_KMODULES_REGEXP,drm.*)
	@$(call add,THE_BRANDING,bootsplash)

use/plymouth/full: use/plymouth/stage2 use/plymouth/base; @:
