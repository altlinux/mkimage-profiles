+icewm: use/x11/icewm; @:
+razorqt: use/x11/razorqt use/x11/lightdm/qt; @:
+tde: use/x11/tde use/x11/kdm; @:
+kde4-lite: use/x11/kde4-lite use/x11/kdm4; @:

use/x11/xorg:
	@$(call add_feature)
	@$(call add,THE_LISTS,xorg)

use/x11/wacom: use/x11/xorg
	@$(call add,THE_PACKAGES,xorg-drv-wacom xorg-drv-wizardpen)

use/x11/drm: use/x11/xorg
	@$(call add,THE_KMODULES,drm drm-radeon)

use/x11/3d-free: use/x11/drm
	@$(call add,THE_KMODULES,drm-nouveau)

### fglrx is broken with xorg-1.13 so far
use/x11/3d-proprietary: use/x11/xorg
	@$(call add,THE_KMODULES,fglrx nvidia)
	@$(call add,THE_PACKAGES,nvidia-settings nvidia-xconfig)
	@$(call add,THE_PACKAGES,fglrx_glx fglrx-tools)

### strictly speaking, runlevel5 should require a *dm, not vice versa
use/x11/runlevel5: use/x11/xorg
	@$(call add,THE_PACKAGES,installer-feature-runlevel5-stage3)

### xdm: see also #23108
use/x11/xdm: use/x11/runlevel5
	@$(call add,THE_PACKAGES,xdm installer-feature-no-xconsole-stage3)

### : some set()-like thing might be better?
use/x11/lightdm/qt use/x11/lightdm/gtk: use/x11/lightdm/%: use/x11/runlevel5
	@$(call add,THE_PACKAGES,lightdm-$*-greeter)

use/x11/kdm: use/x11/runlevel5
	@$(call add,THE_PACKAGES,kdebase-kdm<4)

use/x11/kdm4: use/x11/runlevel5
	@$(call add,THE_PACKAGES,kde4base-workspace-kdm)

use/x11/gdm2.20: use/x11/runlevel5
	@$(call add,THE_PACKAGES,gdm2.20)

use/x11/icewm: use/x11/xorg
	@$(call add,THE_LISTS,$(call tags,icewm desktop))

use/x11/razorqt: use/x11/xorg
	@$(call add,THE_LISTS,$(call tags,razorqt desktop))

use/x11/tde: use/x11/xorg
	@$(call add,THE_LISTS,$(call tags,tde desktop))

use/x11/kde4-lite: use/x11/xorg
	@$(call add,THE_LISTS,$(call tags,kde4 desktop))

use/x11/kde4: use/x11/xorg
	@$(call add,THE_PACKAGES,kde4-default)

use/x11/xfce: use/x11/xorg
	@$(call add,THE_LISTS,$(call tags,xfce desktop))

use/x11/cinnamon: use/x11/xorg use/x11/drm
	@$(call add,THE_LISTS,$(call tags,cinnamon desktop))

use/x11/gnome3: use/x11/xorg use/x11/drm
	@$(call add,THE_PACKAGES,gnome3-default)

use/x11/e17: use/x11/xorg use/x11/3d-free
	@$(call add,THE_LISTS,$(call tags,e17 desktop))

use/x11/lxde: use/x11/xorg
	@$(call add,THE_LISTS,$(call tags,lxde desktop))

use/x11/fvwm: use/x11/xorg
	@$(call add,THE_LISTS,$(call tags,fvwm desktop))
