+plymouth: use/plymouth/full; @:

ifeq (,$(filter-out i586 x86_64 aarch64 e2k% loongarch64,$(ARCH)))
# and a few aliases
use/plymouth/live: use/plymouth/stage2; @:
use/plymouth/install2: use/plymouth/stage2; @:

use/plymouth:
	@$(call add_feature)
	@$(call try,SPLASH_ARGS,quiet splash)

# NB: *_REGEXP due to branding() using regexp and the
#     dependency resolution having to occur within a
#     single transaction (due to plymouth-system-theme)

# looks like there's no sense to pull in progressbars
# while leaving the very basic text bootloader screen
ifeq (distro,$(IMAGE_CLASS))
use/plymouth/stage2: use/plymouth use/branding \
	use/stage2/kms
	@$(call add,STAGE1_PACKAGES,make-initrd-plymouth)
	@$(call add,STAGE1_BRANDING,bootsplash graphics)
	@$(call add,STAGE2_BRANDING,bootsplash graphics)
	@$(call add,STAGE2_BOOTARGS,$$(SPLASH_ARGS))
else
use/plymouth/stage2: use/plymouth use/branding; @:
endif

use/plymouth/base: use/plymouth/stage2 use/drm/full; @:
ifeq (distro,$(IMAGE_CLASS))
	@$(call add,BASE_PACKAGES,installer-feature-setup-plymouth)
endif
	@$(call add,THE_BRANDING,bootsplash graphics)
	@$(call add,BASE_PACKAGES,make-initrd-plymouth cpio)
ifeq (vm,$(IMAGE_CLASS))
	@$(call add,BASE_BOOTARGS,$$(SPLASH_ARGS))
endif

use/plymouth/full: use/plymouth/stage2 use/plymouth/base; @:

else
use/plymouth use/plymouth/live use/plymouth/install2 use/plymouth/stage2 \
	use/plymouth/base use/plymouth/full: ; @:
endif
