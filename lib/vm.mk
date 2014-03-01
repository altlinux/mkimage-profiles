# step 2: build up virtual machine's configuration

ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

ifeq (vm,$(IMAGE_CLASS))

vm/.bare: profile/bare
	@$(call add,BASE_PACKAGES,sysklogd syslogd sysvinit interactivesystem)
	@$(call add,BASE_PACKAGES,lilo shadow-utils e2fsprogs)
	@$(call set,KFLAVOURS,led-ws)
	@$(call add,BASE_KMODULES,guest)

vm/bare: vm/.bare
	@$(call add,BASE_PACKAGES,apt)

endif
