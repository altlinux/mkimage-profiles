use/tty:
	@$(call add_feature)
	@$(call xport,TTY_DEV)
	@$(call xport,TTY_RATE)

use/tty/S0: use/tty
	@$(call add,THE_PACKAGES,agetty)
	@$(call add,TTY_DEV,ttyS0)
	@$(call set,TTY_RATE,115200)
