+x11: use/x11/xorg; @:
+icewm: use/x11/icewm; @:
+xmonad: use/x11/xmonad; @:
+nm-gtk: use/x11/gtk/nm; @:

## hardware support
# the very minimal driver set
use/x11:
	@$(call add_feature)
	@$(call add,THE_LISTS,$(call tags,base xorg))

use/x11/xorg:: use/x11 use/x11/armsoc; @:

# x86: free drivers for various hardware (might lack acceleration)
ifeq (,$(filter-out i586 x86_64 aarch64,$(ARCH)))
use/x11/xorg:: use/x11/intel use/x11/nouveau use/x11/radeon use/x11/amdgpu \
	use/drm/full
	@$(call add,THE_LISTS,$(call tags,desktop xorg))
endif

ifeq (,$(filter-out i586 x86_64,$(ARCH)))
use/x11/intel: use/x11 use/drm
	@$(call add,THE_PACKAGES,xorg-drv-intel)
	@$(call add,THE_PACKAGES,xorg-dri-intel)	### #25044
else
use/x11/intel: use/x11; @:
endif

ifeq (,$(filter-out armh aarch64,$(ARCH)))
use/x11/armsoc: use/x11 use/firmware use/drm
	@$(call add,THE_PACKAGES,xorg-dri-armsoc)
else
use/x11/armsoc: use/x11; @:
endif

ifeq (,$(filter-out e2k%,$(ARCH)))
# e2k: mostly radeon, 101 got mga2/vivante
use/x11/xorg:: use/x11/radeon use/x11/amdgpu use/x11/nouveau use/drm/full

ifeq (,$(filter-out e2kv4,$(ARCH)))
use/x11/mga2: use/x11 use/drm
	@$(call add,THE_PACKAGES,xorg-drv-mga2)
else
use/x11/mga2: use/x11; @:
endif

use/x11/smi: use/x11 use/drm
	@$(call add,THE_PACKAGES,xorg-drv-smi)
else
use/x11/smi: use/x11; @:
endif

# for those cases when no 3D means no use at all
# NB: blobs won't Just Work (TM) along with nouveau/radeon
#     as free drivers get prioritized during autodetection
use/x11/3d: use/x11/intel use/x11/nvidia/optimus use/x11/radeon; @:

# somewhat lacking compared to radeon but still
use/x11/nouveau: use/x11 use/firmware use/drm/nouveau
	@$(call try,NVIDIA_PACKAGES,xorg-drv-nouveau)
	@$(call add,THE_PACKAGES,$$(NVIDIA_PACKAGES))

# has performance problems but is getting better, just not there yet
use/x11/radeon: use/x11 use/firmware use/drm/radeon
	@$(call try,RADEON_PACKAGES,xorg-drv-ati xorg-drv-radeon)
	@$(call add,THE_PACKAGES,$$(RADEON_PACKAGES))

# here's the future
use/x11/amdgpu: use/x11 use/firmware
	@$(call add,THE_PACKAGES,xorg-drv-amdgpu)

# Vulkan is new and bleeding edge, only intel and amgpu(pro?)
use/x11/vulkan: use/x11/intel use/x11/amdgpu
	@$(call add,THE_PACKAGES,vulkan)
	@$(call add,THE_PACKAGES,vulkan-radeon vulkan-intel)

# see https://github.com/NVIDIA/libglvnd for all gory details
use/x11/glvnd: use/x11
	@$(call add,THE_PACKAGES,libglvnd-glx,libglvnd-egl)

# sometimes broken with current xorg-server
use/x11/nvidia:: use/x11/nouveau; @:
use/x11/nvidia/optimus:: use/x11/nvidia; @:

ifeq (,$(filter-out i586 x86_64 aarch64,$(ARCH)))
use/x11/nvidia:: use/drm/nvidia
	@$(call set,NVIDIA_PACKAGES,nvidia-settings nvidia-xconfig)

use/x11/nvidia/optimus:: use/drm/nvidia/optimus
	@$(call add,NVIDIA_PACKAGES,bumblebee primus)
endif

use/x11/wacom: use/x11
	@$(call add,THE_PACKAGES,xorg-drv-wacom)

## display managers
use/x11/dm: use/x11-autostart use/pkgpriorities
	@$(call try,THE_DISPLAY_MANAGER,xdm)
	@$(call add,THE_PACKAGES,$$(THE_DISPLAY_MANAGER))
	@$(call add,PINNED_PACKAGES,$$(THE_DISPLAY_MANAGER))
	@$(call add,DEFAULT_SERVICES_ENABLE,$$(THE_DM_SERVICE))

use/x11/lightdm/gtk use/x11/lightdm/slick \
	use/x11/lightdm/qt use/x11/lightdm/lxqt use/x11/lightdm/kde: \
	use/x11/lightdm/%: use/x11/dm
	@$(call set,THE_DISPLAY_MANAGER,lightdm-$*-greeter)
	@$(call set,THE_DM_SERVICE,lightdm)

use/x11/lxdm use/x11/gdm2.20 use/x11/sddm: \
	use/x11/%: use/x11/dm
	@$(call set,THE_DISPLAY_MANAGER,$*)

use/x11/gdm: \
	use/x11/%: use/x11/dm
	@$(call set,THE_DISPLAY_MANAGER,$*)
	@$(call set,THE_DM_SERVICE,$*)

use/x11/xdm: use/x11/dm
	@$(call set,THE_DISPLAY_MANAGER,xdm)
	@$(call add,THE_PACKAGES,installer-feature-no-xconsole-stage3)

## window managers and desktop environments
use/x11/icewm: use/x11
	@$(call add,THE_LISTS,$(call tags,icewm desktop))

use/x11/kde/synaptic:
	@$(call add,THE_PACKAGES,synaptic-kde synaptic-usermode-)

use/x11/gtk/nm: use/net/nm
	@$(call add,THE_LISTS,$(call tags,desktop nm))

use/x11/xfce: use/x11
	@$(call add,THE_PACKAGES,xfce4-regular)
	@$(call add,IM_PACKAGES,imsettings-xfce)

use/x11/xfce/full: use/x11/xfce +pulse
	@$(call add,THE_PACKAGES,xfce4-full)

use/x11/cinnamon: use/x11/xorg +pulse
	@$(call add,THE_LISTS,$(call tags,cinnamon desktop))
	@$(call add,IM_PACKAGES,imsettings-cinnamon)

use/x11/deepin: use/x11/xorg +pulse
	@$(call add,THE_PACKAGES,deepin-default)

use/x11/gnome3: use/x11/xorg use/x11/gdm +pulse
	@$(call add,THE_PACKAGES,gnome3-default)
	@$(call add,IM_PACKAGES,imsettings-gsettings)

use/x11/enlightenment: use/x11 use/net/connman +pulse
	@$(call add,THE_LISTS,$(call tags,enlightenment desktop))

use/x11/lxde: use/x11
	@$(call add,THE_LISTS,$(call tags,lxde desktop))
	@$(call add,IM_PACKAGES,imsettings-lxde)

use/x11/lxqt: use/x11 +pulse
	@$(call add,THE_LISTS,$(call tags,desktop && lxqt && !extra))
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

use/x11/mate: use/x11 +pulse
	@$(call add,THE_LISTS,$(call tags,mate desktop))
	@$(call add,IM_PACKAGES,imsettings-mate)

use/x11/dwm: use/x11
	@$(call add,THE_LISTS,$(call tags,dwm desktop))

use/x11/leechcraft: use/x11
	@$(call add,THE_PACKAGES,leechcraft)

use/x11/kde5: use/x11/xorg use/x11/kde/synaptic
	@$(call add,THE_PACKAGES,kde5-big)
