# step 2: build up virtual environment's configuration

ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

# NB: ve/ targets should be defined in this file
VE_TARGETS := $(shell sed -n 's,^\(ve/[^:.]\+\):.*$$,\1,p' \
	        $(lastword $(MAKEFILE_LIST)) | sort)

ifeq (ve,$(IMAGE_CLASS))

.PHONY: $(VE_TARGETS)

ve/.bare: profile/bare
	@$(call add,BASE_PACKAGES,basesystem)

ve/generic: ve/.bare
	@$(call add,BASE_LISTS,\
		$(call tags,base && (server || network || security || pkg)))

ve/openvpn: ve/.bare
	@$(call add,BASE_LISTS,$(call tags,server openvpn))

# NB: if there are too many screens above, it might make sense to ve.d/
endif
