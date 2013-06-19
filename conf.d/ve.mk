ifeq (ve,$(IMAGE_CLASS))

# no "vzctl enter"
ve/bare: ve/.base
	@$(call add,BASE_PACKAGES,sysvinit)

# /dev/pty and friends start here
ve/base: ve/bare
	@$(call add,BASE_PACKAGES,interactivesystem)

# this should be more or less deployable
ve/generic: ve/base
	@$(call add,BASE_LISTS,openssh \
		$(call tags,base && (server || network || security || pkg)))

# example of service-specific template
ve/openvpn: ve/bare
	@$(call add,BASE_LISTS,$(call tags,server openvpn))

endif
