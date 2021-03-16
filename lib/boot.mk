ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

ifeq (distro,$(IMAGE_CLASS))

# install media bootloader
boot/iso:
	@$(call try,IMAGE_PACKTYPE,boot)
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call try,BOOTLOADER,isolinux)
endif
ifeq (,$(filter-out aarch64 riscv64,$(ARCH)))
	@$(call try,BOOTLOADER,efiboot)
endif
ifeq (,$(filter-out e2k%,$(ARCH)))
	@$(call try,BOOTLOADER,e2k-boot)
endif
ifeq (,$(filter-out ppc64le,$(ARCH)))
	@$(call try,BOOTLOADER,ieee1275boot)
endif

endif
