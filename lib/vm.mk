# step 2: build up virtual machine's configuration

ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

ifeq (vm,$(IMAGE_CLASS))

#vm/.bare: profile/bare use/bootloader/grub
vm/.bare: profile/bare
	@$(call add,BASE_PACKAGES,basesystem interactivesystem lilo passwd shadow-utils e2fsprogs mingetty)
	@$(call set,KFLAVOURS,std-def)

vm/bare: vm/.bare
	@$(call add,BASE_PACKAGES,apt)

endif
