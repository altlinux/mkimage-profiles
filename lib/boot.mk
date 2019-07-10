ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

ifeq (distro,$(IMAGE_CLASS))

# install x86 media bootloader
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
boot/iso: use/syslinux
	@$(call set,BOOTLOADER,isolinux)
endif

# install aarch64 media bootloader
ifeq (,$(filter-out aarch64,$(ARCH)))
boot/iso:
	@$(call set,BOOTLOADER,grubaa64boot)
endif

# firmware is the bootloader
ifeq (,$(filter-out e2k%,$(ARCH)))
boot/iso:
	@$(call set,BOOTLOADER,e2k-boot)
endif

# install bootloader for Open Boot (IEEE1275)
ifeq (,$(filter-out ppc64le,$(ARCH)))
boot/iso:
	@$(call set,BOOTLOADER,ieee1275boot)
endif

endif
