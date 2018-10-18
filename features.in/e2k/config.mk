use/e2k:
	@$(call add_feature)
	@$(call add,BASE_PACKAGES,installer-feature-e2k-fix-clock-stage3)

# at least one of these is requisite
use/e2k/1cp use/e2k/4c use/e2k/8c: use/e2k/%: use/e2k
	@$(call set,KFLAVOURS,elbrus-$*)

use/e2k/x11: use/e2k use/x11
	@$(call add,THE_PACKAGES,xorg-server xinit)

use/e2k/x11/401: use/e2k/x11 use/e2k/4c
	@$(call add,THE_PACKAGES,xorg-conf-e401-radeon)
	@$(call add,THE_PACKAGES,xorg-drv-ati)

use/e2k/x11/801: use/e2k/x11 use/e2k/8c
	@$(call add,THE_PACKAGES,xorg-conf-e801-radeon)
	@$(call add,THE_PACKAGES,xorg-drv-ati)

use/e2k/x11/.101: use/e2k/x11 use/e2k/1cp; @:

use/e2k/x11/101/modesetting: use/e2k/x11/.101
	@$(call add,THE_PACKAGES,xorg-conf-e101-modesetting)
	@$(call add,THE_PACKAGES,dummy-xorg-drv-vivante)

use/e2k/x11/101/mga2: use/e2k/x11/.101
	@$(call add,THE_PACKAGES,xorg-conf-e101-mga2)
	@$(call add,THE_PACKAGES,xorg-drv-mga2 vivante_glx)

use/e2k/x11/101: use/e2k/x11/101/modesetting
	@$(call add,MAIN_PACKAGES,xorg-conf-e101-mga2)
	@$(call add,MAIN_PACKAGES,xorg-drv-mga2 vivante_glx)

use/e2k/install2: use/e2k
	@$(call add,INSTALL2_PACKAGES,installer-feature-e2k-fix-boot-stage2)
	@$(call add,INSTALL2_PACKAGES,installer-feature-fstrim-stage2)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,llvm)

use/e2k/install2/desktop: use/e2k/install2
	@$(call add,INSTALL2_PACKAGES,installer-feature-e2k-ignore-cf-stage2)

use/e2k/install2/4xx: use/e2k/install2 use/e2k/4c
	@$(call add,INSTALL2_PACKAGES,xorg-conf-e4xx-fbdev)

use/e2k/install2/401: use/e2k/install2/desktop use/e2k/4c
	@$(call add,INSTALL2_PACKAGES,xorg-conf-e401-modesetting)

use/e2k/install2/801: use/e2k/install2/desktop use/e2k/8c
	@$(call add,INSTALL2_PACKAGES,xorg-conf-e801-modesetting)

use/e2k/install2/101: use/e2k/install2/desktop use/e2k/1cp
	@$(call add,INSTALL2_PACKAGES,xorg-conf-e101-modesetting)
	@$(call add,INSTALL2_PACKAGES,dummy-xorg-drv-vivante)

use/e2k/sound/401:
	@$(call add,THE_PACKAGES,setup-alsa-elbrus-401)

use/e2k/401: use/e2k/install2/401 use/e2k/x11/401 use/e2k/sound/401; @:
use/e2k/801: use/e2k/install2/801 use/e2k/x11/801; @:
use/e2k/101: use/e2k/install2/101 use/e2k/x11/101; @:
