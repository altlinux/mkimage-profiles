use/x11/xorg:
	@$(call add,THE_LISTS,xorg)
	@$(call add,THE_KMODULES,drm)

use/x11/wacom: use/x11/xorg
	@$(call add,THE_PACKAGES,xorg-drv-wacom)

### strictly speaking, runlevel5 should require a *dm, not vice versa
use/x11/runlevel5: use/x11/xorg
	@$(call add,THE_PACKAGES,installer-feature-runlevel5-stage3)

### xdm: see also #23108
use/x11/xdm: use/x11/runlevel5
	@$(call add,THE_PACKAGES,xdm installer-feature-no-xconsole)

### : some set()-like thing might be better?
use/x11/lightdm: use/x11/runlevel5
	@$(call add,THE_PACKAGES,lightdm)
