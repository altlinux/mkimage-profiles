# step 2: build up virtual machine's configuration

ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

ifeq (vm,$(IMAGE_CLASS))

vm/.bare: profile/bare
	@$(call add,BASE_PACKAGES,interactivesystem shadow-utils e2fsprogs)

ifeq (,$(filter-out i586 x86_64,$(ARCH)))
vm/.base-lilo: vm/.bare use/bootloader/lilo; @:
endif

ifeq (,$(filter-out i586 x86_64,$(ARCH)))
vm/.base-grub: vm/.bare use/bootloader/grub; @:
endif

ifeq (,$(filter-out i586 x86_64 aarch64,$(ARCH)))
vm/.base-grub-efi: vm/.bare use/efi/grub; @:
endif

endif
