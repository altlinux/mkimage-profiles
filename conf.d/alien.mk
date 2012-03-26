ve/.centos-base: ve/.bare
	@$(call set,IMAGE_INIT_LIST,hasher-pkg-init)

ve/centos: ve/.centos-base
	@$(call add,BASE_PACKAGES,openssh-server)

