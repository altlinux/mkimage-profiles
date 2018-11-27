# step 2: build up virtual machine's configuration

ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

ifeq (vm,$(IMAGE_CLASS))

vm/.bare: profile/bare
	@$(call add,BASE_PACKAGES,interactivesystem shadow-utils e2fsprogs)

ifeq (,$(filter-out i586 x86_64,$(ARCH)))
vm/.base-lilo: vm/.bare
	@$(call add,BASE_PACKAGES,lilo)
endif

ifeq (,$(filter-out i586 x86_64,$(ARCH)))
vm/.base-grub: vm/.bare
	@$(call add,BASE_PACKAGES,grub2-pc)
endif

ifeq (,$(filter-out i586 x86_64 aarch64,$(ARCH)))
vm/.base-grub-efi: vm/.bare
	@$(call add,BASE_PACKAGES,grub2-efi)
endif

endif
