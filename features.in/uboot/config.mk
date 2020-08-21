ifeq (,$(filter-out qcow2 qcow2c,$(IMAGE_TYPE)))
ifeq (,$(filter-out aarch64 armh,$(ARCH)))
UBOOT_TTY := use/tty/AMA0
else
UBOOT_TTY := use/tty/S0
endif
endif

ifeq (,$(filter-out riscv64,$(ARCH)))
UBOOT_TTY := use/tty/S0
endif

ifneq (,$(filter-out i586 x86_64,$(ARCH)))
use/uboot: use/kernel/initrd-setup $(UBOOT_TTY)
	@$(call add_feature)
	@$(call add,THE_LISTS,singleboard-tools)
ifeq (,$(filter-out aarch64 armh,$(ARCH)))
	@$(call add,UBOOT_BOOTARGS,cma=192M)
endif
ifeq (,$(filter-out riscv64,$(ARCH)))
	@$(call add,UBOOT_BOOTARGS,earlyprintk debug no_alt_virt_keyboard)
endif
	@$(call xport,UBOOT_BOOTARGS)
else
use/uboot: ; @:
endif
