+plymouth: use/plymouth/full; @:

ifeq (,$(filter-out i586 x86_64,$(ARCH)))
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
ifeq (distro,$(IMAGE_CLASS))
use/plymouth/stage2: use/plymouth use/branding \
	use/stage2/kms
	@$(call add,STAGE1_PACKAGES_REGEXP,make-initrd-plymouth)
	@$(call add,STAGE1_BRANDING,bootsplash)
	@$(call add,STAGE2_BRANDING,bootsplash)
	@$(call add,STAGE2_BOOTARGS,quiet splash)
else
use/plymouth/stage2: use/plymouth use/branding; @:
endif

ifeq (vm,$(IMAGE_CLASS))
use/plymouth/vm: use/plymouth use/branding use/kernel/initrd-setup
	@$(call add,VM_INITRDFEATURES,plymouth)
	@$(call add,THE_BRANDING,bootsplash)
	@$(call add,THE_PACKAGES_REGEXP,make-initrd-plymouth)
	@$(call add,BASE_BOOTARGS,quiet)
	@$(call add,THE_KMODULES,drm)
else
use/plymouth/vm: use/plymouth; @:
endif

use/plymouth/base: use/plymouth/stage2 use/plymouth/vm \
	use/drm/full; @:
ifeq (distro,$(IMAGE_CLASS))
	@$(call add,INSTALL2_PACKAGES,installer-feature-setup-plymouth)
endif
	@$(call add,BASE_PACKAGES_REGEXP,make-initrd-plymouth cpio)
	@$(call add,THE_BRANDING,bootsplash)
	@$(call add,THE_PACKAGES,make-initrd-plymouth)
	@$(call add,BASE_BOOTARGS,splash)

use/plymouth/full: use/plymouth/stage2 use/plymouth/base; @:

else
use/plymouth use/plymouth/live use/plymouth/install2 use/plymouth/stage2 \
	use/plymouth/base use/plymouth/full: ; @:
endif
