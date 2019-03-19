# step 2: build up virtual environment's configuration

ifndef MKIMAGE_PROFILES
$(error this makefile is designed to be included in toplevel one)
endif

ifeq (ve,$(IMAGE_CLASS))

# no package management and networking
ve/.bare: profile/bare
	@$(call add,BASE_PACKAGES,basesystem)

# add package management
ve/.apt: ve/.bare
	@$(call add,BASE_PACKAGES,apt)

# also add networking
ve/.base: ve/.apt
	@$(call add,BASE_PACKAGES,etcnet)

endif
