ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

ifeq (distro,$(IMAGE_CLASS))

# install x86 media bootloader
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
boot/iso: use/syslinux
	@$(call set,BOOTLOADER,isolinux)
endif

# firmware is the bootloader
ifeq (,$(filter-out e2k%,$(ARCH)))
boot/iso:
	@$(call set,BOOTLOADER,e2k-boot)
endif

endif
