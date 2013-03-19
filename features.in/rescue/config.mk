use/rescue: use/stage2 sub/stage2@rescue use/syslinux/sdab.cfg \
	use/firmware/full +wireless
	@$(call add_feature)
	@$(call add,RESCUE_LISTS, openssh \
		$(call tags,(base || extra || server || misc) && \
			(rescue || network || security)))

# rw slice, see also use/live/rw (don't use simultaneously)
ifeq (,$(EFI_BOOTLOADER))
use/rescue/rw: use/rescue use/syslinux
	@$(call add,SYSLINUX_CFG,rescue_rw)
else
use/rescue/rw: use/rescue; @:
endif
