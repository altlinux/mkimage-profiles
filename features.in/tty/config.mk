use/tty:
	@$(call add_feature)
	@$(call xport,TTY_DEV)
	@$(call xport,TTY_RATE)
ifeq (distro,$(IMAGE_CLASS))
	@$(call add,BASE_PACKAGES,installer-feature-serial-stage3)
endif

use/tty/S0: use/tty
	@$(call add,THE_PACKAGES,agetty)
	@$(call add,TTY_DEV,ttyS0)
	@$(call set,TTY_RATE,115200)
	@$(call add,SYSLINUX_CFG,ttyS0)
