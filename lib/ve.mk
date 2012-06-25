# step 2: build up virtual environment's configuration

ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

ifeq (ve,$(IMAGE_CLASS))

ve/.bare: profile/bare
	@$(call add,BASE_PACKAGES,basesystem)

ve/bare: ve/.bare
	@$(call add,BASE_PACKAGES,apt)

ve/generic: ve/.bare
	@$(call add,BASE_LISTS,openssh \
		$(call tags,base && (server || network || security || pkg)))

ve/openvpn: ve/.bare
	@$(call add,BASE_LISTS,$(call tags,server openvpn))

endif
