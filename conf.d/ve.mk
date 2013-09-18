ifeq (ve,$(IMAGE_CLASS))

# no "vzctl enter"
ve/bare: ve/.base use/init/sysv; @:

# /dev/pty and friends start here
ve/base: ve/bare
	@$(call add,BASE_PACKAGES,interactivesystem)

# a particular package list
ve/ldv: ve/bare
	@$(call add,BASE_PACKAGES,xz bzip2 glibc hostinfo less)
	@$(call add,BASE_PACKAGES,vim-console netlist rsync time)
	@$(call add,BASE_PACKAGES,openssh-blacklist openssh-server)
	@$(call add,BASE_PACKAGES,shadow-edit shadow-groups)

# this should be more or less convenient
ve/generic: ve/base use/repo
	@$(call add,BASE_PACKAGES,vim-console etckeeper)
	@$(call add,BASE_LISTS,openssh \
		$(call tags,base && (server || network || security || pkg)))

# example of service-specific template
ve/openvpn: ve/bare
	@$(call add,BASE_LISTS,$(call tags,server openvpn))

endif
