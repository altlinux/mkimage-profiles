+icewm: use/x11/icewm; @:
+xmonad: use/x11/xmonad; @:
+tde: use/x11/tde use/x11/kdm; @:
+kde4-lite: use/x11/kde4-lite use/x11/kdm4; @:

# the very minimal driver set
use/x11:
	@$(call add_feature)
	@$(call add,THE_KMODULES,drm)	# required by recent nvidia.ko as well
	@$(call add,THE_LISTS,$(call tags,base xorg))

# x86: free drivers for various hardware (might lack acceleration)
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
use/x11/xorg: use/x11 use/x11/intel use/firmware
	@$(call add,THE_KMODULES,drm-radeon drm-nouveau)
	@$(call add,THE_LISTS,$(call tags,desktop xorg))
else
use/x11/xorg: use/x11; @:
endif

# both free and excellent
use/x11/intel: use/x11
	@$(call add,THE_PACKAGES,xorg-drv-intel)
	@$(call add,THE_PACKAGES,xorg-dri-intel)	### #25044

# for those cases when no 3D means no use at all
# NB: blobs won't Just Work (TM) with use/x11/xorg,
#     nouveau gets prioritized during autodetection
#use/x11/3d: use/x11/intel use/x11/nvidia use/x11/fglrx; @:
use/x11/3d: use/x11/intel use/x11/nvidia/optimus use/x11/radeon; @:

# has performance problems but is getting better, just not there yet
use/x11/radeon: use/x11 use/firmware
	@$(call add,THE_KMODULES,drm-radeon)
	@$(call add,THE_PACKAGES,xorg-drv-ati xorg-drv-radeon)

# sometimes broken with current xorg-server
use/x11/nvidia: use/x11
	@$(call add,THE_KMODULES,nvidia)
	@$(call add,THE_PACKAGES,nvidia-settings nvidia-xconfig)

use/x11/nvidia/optimus: use/x11/nvidia
	@$(call add,THE_KMODULES,bbswitch)
	@$(call add,THE_PACKAGES,bumblebee primus)

# oftenly broken with current xorg-server, use radeon then
use/x11/fglrx: use/x11
	@$(call add,THE_KMODULES,fglrx)
	@$(call add,THE_PACKAGES,fglrx_glx fglrx-tools)

use/x11/wacom: use/x11
	@$(call add,THE_PACKAGES,xorg-drv-wacom xorg-drv-wizardpen)

### xdm: see also #23108
use/x11/xdm: use/x11-autostart
	@$(call add,THE_PACKAGES,xdm installer-feature-no-xconsole-stage3)

### : some set()-like thing might be better?
use/x11/lightdm/gtk use/x11/lightdm/qt use/x11/lightdm/lxqt \
	use/x11/lightdm/kde: use/x11/lightdm/%: use/x11-autostart
	@$(call add,THE_PACKAGES,lightdm-$*-greeter)

use/x11/kdm: use/x11-autostart
	@$(call add,THE_PACKAGES,kdebase-kdm<4)

use/x11/kdm4: use/x11-autostart
	@$(call add,THE_PACKAGES,kde4base-workspace-kdm)

use/x11/gdm2.20: use/x11-autostart
	@$(call add,THE_PACKAGES,gdm2.20)

use/x11/sddm: use/x11-autostart
	@$(call add,THE_PACKAGES,sddm)

use/x11/icewm: use/x11
	@$(call add,THE_LISTS,$(call tags,icewm desktop))

use/x11/tde: use/x11
	@$(call add,THE_LISTS,$(call tags,tde desktop))

use/x11/kde4-lite: use/x11
	@$(call add,THE_LISTS,$(call tags,kde4 desktop))

use/x11/kde4: use/x11
	@$(call add,THE_PACKAGES,kde4-default)
	@$(call add,IM_PACKAGES,imsettings-qt)

# handle both p7/t7 (p-a-nm) and sisyphus (k-p-nm) cases
use/x11/kde4/nm: use/x11/kde4 use/net/nm
	@$(call add,THE_PACKAGES_REGEXP,^kde4-plasma-nm.*)
	@$(call add,THE_PACKAGES_REGEXP,^plasma-applet-networkmanager.*)

use/x11/gtk/nm: use/net/nm
	@$(call add,THE_LISTS,$(call tags,desktop nm))

use/x11/xfce: use/x11
	@$(call add,THE_LISTS,$(call tags,xfce desktop))
	@$(call add,IM_PACKAGES,imsettings-xfce)

use/x11/cinnamon: use/x11/xorg
	@$(call add,THE_LISTS,$(call tags,cinnamon desktop))
	@$(call add,IM_PACKAGES,imsettings-cinnamon)

use/x11/gnome3: use/x11/xorg +pulse
	@$(call add,THE_PACKAGES,gnome3-default)
	@$(call add,IM_PACKAGES,imsettings-gsettings)

use/x11/e17: use/x11 use/net/connman
	@$(call add,THE_LISTS,$(call tags,e17 desktop))

use/x11/enlightenment: use/x11 use/net/connman
	@$(call add,THE_LISTS,$(call tags,enlightenment desktop))
	@$(call add,DEFAULT_SERVICES_DISABLE,acpid)

use/x11/lxde: use/x11
	@$(call add,THE_LISTS,$(call tags,lxde desktop))
	@$(call add,IM_PACKAGES,imsettings-lxde)

use/x11/lxqt: use/x11
	@$(call add,THE_LISTS,$(call tags,lxqt desktop))
	@$(call add,IM_PACKAGES,imsettings-qt)

use/x11/fvwm: use/x11
	@$(call add,THE_LISTS,$(call tags,fvwm desktop))

use/x11/sugar: use/x11
	@$(call add,THE_LISTS,$(call tags,sugar desktop))

use/x11/wmaker: use/x11
	@$(call add,THE_LISTS,$(call tags,wmaker desktop))

use/x11/gnustep: use/x11
	@$(call add,THE_LISTS,$(call tags,gnustep desktop))

use/x11/xmonad: use/x11
	@$(call add,THE_LISTS,$(call tags,xmonad desktop))

use/x11/mate: use/x11
	@$(call add,THE_LISTS,$(call tags,mate desktop))
	@$(call add,IM_PACKAGES,imsettings-mate)

use/x11/dwm: use/x11
	@$(call add,THE_LISTS,$(call tags,dwm desktop))

use/x11/leechcraft: use/x11
	@$(call add,THE_PACKAGES,leechcraft)

use/x11/kde5: use/x11/xorg
	@$(call add,THE_PACKAGES,kde5-big kf5-i18n-ru kde5-i18n-ru)
