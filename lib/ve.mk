# step 2: build up virtual environment's configuration

ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

ifeq (ve,$(IMAGE_CLASS))

# no package management and networking
ve/.bare: profile/bare
	@$(call add,BASE_PACKAGES,basesystem)

# add those
ve/.base: ve/.bare
	@$(call add,BASE_PACKAGES,etcnet apt)

endif
