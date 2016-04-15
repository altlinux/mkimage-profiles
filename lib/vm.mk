# step 2: build up virtual machine's configuration

ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

ifeq (vm,$(IMAGE_CLASS))

vm/.bare: profile/bare
	@$(call add,BASE_PACKAGES,interactivesystem shadow-utils e2fsprogs)
ifeq (,$(filter-out i586 x86_64,$(ARCH)))	# useless on anything else
	@$(call add,BASE_PACKAGES,lilo)
endif

endif
