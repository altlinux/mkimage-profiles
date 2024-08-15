LUKS_LISTS := $(call tags,security luks)

use/luks:
	@$(call add_feature)
	@$(call add,BASE_PACKAGES,make-initrd-luks)
	@$(call add,THE_LISTS,$(LUKS_LISTS))
	@$(call add,RESCUE_LISTS,$(LUKS_LISTS))
ifeq (distro,$(IMAGE_CLASS))
	@$(call add,BASE_PACKAGES,alterator-luks)
endif

use/luks/touchscreen: use/luks use/plymouth/base
	@$(call add,BASE_PACKAGES,unl0kr)
	@$(call add,VM_INITRDMODULES,drivers/input/touchscreen)
