use/tty:
	@$(call add_feature)
	@$(call xport,TTY_DEV)
	@$(call xport,TTY_RATE)
	@$(call xport,BASE_BOOTARGS)
	@$(call add,GRUB_CFG,serial-console)
ifeq (distro,$(IMAGE_CLASS))
	@$(call add,INSTALL2_PACKAGES,installer-feature-serial-stage2)
	@$(call add,THE_PACKAGES,installer-feature-serial-stage3)
endif

comma := ,
use/tty/%: use/tty
	@$(call add,THE_PACKAGES,agetty)
	@$(call try,TTY_DEV,tty$*)
	@$(call try,TTY_RATE,115200)
ifeq (distro,$(IMAGE_CLASS))
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call add,GRUB_CFG,serial)
	@$(call add,SYSLINUX_CFG,tty$*)
endif
endif
	@$(call add,BASE_BOOTARGS,console=tty0 console=$$(TTY_DEV)$(comma)$$(TTY_RATE)n8)
