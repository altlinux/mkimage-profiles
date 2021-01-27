use/tty:
	@$(call add_feature)
	@$(call xport,TTY_DEV)
	@$(call xport,TTY_RATE)
	@$(call xport,BASE_BOOTARGS)
ifeq (distro,$(IMAGE_CLASS))
	@$(call add,INSTALL2_PACKAGES,installer-feature-serial-stage2)
	@$(call add,BASE_PACKAGES,installer-feature-serial-stage3)
endif

comma := ,
use/tty/S0 use/tty/SIF0 use/tty/AMA0: use/tty/%: use/tty
	@$(call add,THE_PACKAGES,agetty)
	@$(call add,TTY_DEV,tty$*)
	@$(call set,TTY_RATE,115200)
	@$(call add,SYSLINUX_CFG,tty$*)
	@$(call add,BASE_BOOTARGS,console=tty1 console=$$(TTY_DEV)$(comma)$$(TTY_RATE)n8)
