ifeq (,$(filter-out qcow2 qcow2c,$(IMAGE_TYPE)))
ifeq (,$(filter-out aarch64,$(ARCH)))
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
ifeq (,$(filter-out riscv64,$(ARCH)))
	@$(call add,UBOOT_BOOTARGS,earlyprintk no_alt_virt_keyboard)
endif
	@$(call try,UBOOT_TIMEOUT,50)
	@$(call xport,UBOOT_BOOTARGS)
	@$(call xport,UBOOT_TIMEOUT)
	@$(call xport,UBOOT_NOFDTDIR)
else
use/uboot: ; @:
endif
