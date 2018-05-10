ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

ifeq (distro,$(IMAGE_CLASS))
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
# install media bootloader
boot/isolinux: use/syslinux
	@$(call set,BOOTLOADER,isolinux)
endif
ifeq (,$(filter-out e2k%,$(ARCH)))
boot/isolinux:
	@$(call set,BOOTLOADER,e2k-boot)
endif
endif
