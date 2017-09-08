use/e2k:
	@$(call add_feature)
	@$(call set,KFLAVOURS,mcst-def)

use/e2k/x11: use/e2k use/x11
	@$(call add,THE_PACKAGES,xorg-conf-e401-radeon)
	@$(call add,THE_PACKAGES,xorg-drv-ati xinit)

use/e2k/sound:
	@$(call add,THE_PACKAGES,setup-alsa-elbrus-401)
