ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

ifeq (distro,$(IMAGE_CLASS))
# install media bootloader
boot/isolinux: use/syslinux
	@$(call set,BOOTLOADER,isolinux)
endif
