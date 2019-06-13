ifeq (,$(filter-out qcow2 qcow2c,$(IMAGE_TYPE)))
ifeq (,$(filter-out aarch64 armh,$(ARCH)))
UBOOT_TTY := use/tty/AMA0
else
UBOOT_TTY := /use/tty/S0
endif
endif

use/uboot: use/kernel/initrd-setup $(UBOOT_TTY)
	@$(call add_feature)
	@$(call add,THE_LISTS,singleboard-tools)
	@$(call try,TTY_DEV,tty1)
	@$(call xport,TTY_DEV)
