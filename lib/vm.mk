# step 2: build up virtual machine's configuration

ifeq (,$(MKIMAGE_PROFILES))
$(error this makefile is designed to be included in toplevel one)
endif

ifeq (vm,$(IMAGE_CLASS))

vm/.bare: profile/bare use/branding/notes
	@$(call add,BASE_PACKAGES,interactivesystem shadow-utils e2fsprogs)

ifeq (,$(filter-out i586 x86_64,$(ARCH)))
vm/.base-grub: vm/.bare use/bootloader/grub; @:
else
vm/.base-grub: vm/.base-grub-efi; @:
endif

ifeq (,$(filter-out x86_64 aarch64 riscv64 loongarch64,$(ARCH)))
vm/.base-grub-efi: vm/.bare use/efi/grub; @:
else
vm/.base-grub-efi: vm/.bare; @:
endif

endif
