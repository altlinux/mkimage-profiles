+x11: use/x11/xorg; @:
+icewm: use/x11/icewm; @:
+xmonad: use/x11/xmonad; @:
+nm-gtk: use/x11/gtk/nm; @:
+nm-gtk4: use/x11/gtk4/nm; @:
+screensaver: use/x11/xscreensaver/gl; @:

## hardware support
# the very minimal driver set
use/x11:
	@$(call add_feature)
	@$(call add,THE_LISTS,$(call tags,base xorg))

use/x11/xorg:: use/x11 use/x11/intel use/drm
	@$(call add,THE_LISTS,$(call tags,desktop xorg))
	@$(call add,THE_LISTS,mesa-dri-drivers)

# x86: free drivers for various hardware (might lack acceleration)
ifeq (,$(filter-out i586 x86_64 aarch64,$(ARCH)))
ifeq (distro,$(IMAGE_CLASS))
use/x11/xorg:: use/x11/nouveau use/x11/radeon use/x11/amdgpu \
	use/drm/full; @:
endif
endif

ifeq (,$(filter-out riscv64,$(ARCH)))
use/x11/xorg:: use/x11/amdgpu; @:
endif

ifeq (,$(filter-out loongarch64,$(ARCH)))
use/x11/xorg:: use/x11/radeon use/x11/amdgpu; @:
endif

ifeq (,$(filter-out i586 x86_64,$(ARCH)))
use/x11/intel: use/x11 use/drm
	@$(call add,THE_PACKAGES,xorg-drv-intel)
	@$(call add,THE_PACKAGES,xorg-dri-intel)	### #25044
else
use/x11/intel: use/x11; @:
endif

use/x11/armsoc: use/x11/xorg; @:

ifeq (,$(filter-out e2k%,$(ARCH)))
# e2k: mostly radeon, 101 got mga2/vivante
use/x11/xorg:: use/x11/radeon use/x11/amdgpu use/x11/nouveau use/drm/full

ifeq (,$(filter-out e2kv4 e2kv6,$(ARCH)))
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
use/x11/3d: use/x11/intel use/x11/radeon use/x11/amdgpu use/x11/nvidia; @:

# somewhat lacking compared to radeon but still
use/x11/nouveau: use/x11 use/firmware use/drm/nouveau
	@$(call try,NVIDIA_PACKAGES,xorg-drv-nouveau)
	@$(call add,THE_PACKAGES,$$(NVIDIA_PACKAGES))

# has performance problems but is getting better, just not there yet
use/x11/radeon: use/x11 use/firmware use/drm/radeon
	@$(call add,THE_PACKAGES,xorg-drv-ati xorg-drv-radeon)

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
	@$(call set,NVIDIA_PACKAGES,nvidia-settings)
	@$(call add,RESCUE_BOOTARGS,module_blacklist=nvidia)

use/x11/nvidia/optimus:: use/drm/nvidia/optimus
	@$(call add,NVIDIA_PACKAGES,bumblebee)
endif

use/x11/wacom: use/x11
	@$(call add,THE_PACKAGES,xorg-drv-wacom)

## display managers
use/x11/dm: use/x11-autostart use/pkgpriorities
	@$(call try,THE_DISPLAY_MANAGER,xdm)
	@$(call try,THE_DM_SERVICE,dm)
	@$(call add,THE_PACKAGES,$$(THE_DISPLAY_MANAGER))
	@$(call add,PINNED_PACKAGES,$$(THE_DISPLAY_MANAGER))
	@$(call add,DEFAULT_SERVICES_ENABLE,$$(THE_DM_SERVICE))

use/x11/lightdm/gtk use/x11/lightdm/slick use/x11/lightdm/kde\
	use/x11/lightdm/autologin: \
	use/x11/lightdm/%: use/x11/dm
	@$(call set,THE_DISPLAY_MANAGER,lightdm-$*-greeter)
	@$(call set,THE_DM_SERVICE,lightdm)

use/x11/kde-display-manager-lightdm: \
	use/x11/%: use/x11/dm
ifeq (,$(filter-out sisyphus,$(BRANCH)))
	@$(call set,THE_DISPLAY_MANAGER,kde-display-manager-7-lightdm)
else
	@$(call set,THE_DISPLAY_MANAGER,kde5-display-manager-7-lightdm)
endif
	@$(call set,THE_DM_SERVICE,lightdm)

use/x11/gdm use/x11/sddm use/x11/lxdm: \
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
	@$(call add,THE_LISTS,network/NetworkManager-gtk)

ifeq (,$(filter-out sisyphus p11,$(BRANCH)))
use/x11/gtk4/nm: use/net/nm
	@$(call add,THE_LISTS,network/NetworkManager-gtk4)
else
use/x11/gtk4/nm: use/x11/gtk/nm; @:
endif

use/x11/xfce: use/x11
	@$(call add,THE_LISTS,xfce/xfce4-default)
	@$(call add,IM_PACKAGES,imsettings-xfce)

use/x11/xfce/full: use/x11/xfce +pipewire
	@$(call add,THE_LISTS,xfce/xfce4-full)

use/x11/cinnamon: use/x11/xorg +pipewire
	@$(call add,THE_LISTS,$(call tags,cinnamon desktop))
	@$(call add,IM_PACKAGES,imsettings-cinnamon)

use/x11/deepin: use/x11/xorg +pipewire
	@$(call add,THE_LISTS,$(call tags,deepin desktop))

use/x11/gnome: use/x11/xorg use/x11/gdm +pipewire
	@$(call add,THE_LISTS,gnome/gnome-minimal)
ifeq (,$(filter-out p10,$(BRANCH)))
	@$(call add,THE_PACKAGES,tracker3) # ALT bug 42028
endif
	@$(call add,IM_PACKAGES,imsettings-gsettings)

use/x11/enlightenment: use/x11 use/power/acpi +pipewire +nm-gtk
	@$(call add,THE_LISTS,$(call tags,enlightenment desktop))

use/x11/lxde: use/x11
	@$(call add,THE_LISTS,$(call tags,lxde desktop))
	@$(call add,IM_PACKAGES,imsettings-lxde)

use/x11/lxqt: use/x11 +pipewire
	@$(call add,THE_LISTS,$(call tags,desktop && lxqt))
	@$(call add,IM_PACKAGES,imsettings-qt)

use/x11/fvwm: use/x11
	@$(call add,THE_LISTS,$(call tags,fvwm desktop))

use/x11/wmaker: use/x11
	@$(call add,THE_LISTS,$(call tags,wmaker desktop))

use/x11/gnustep: use/x11
	@$(call add,THE_LISTS,$(call tags,gnustep desktop))

use/x11/mate: use/x11 +pipewire
	@$(call add,THE_LISTS,$(call tags,mate desktop))
	@$(call add,IM_PACKAGES,imsettings-mate)

use/x11/dwm: use/x11
	@$(call add,THE_LISTS,$(call tags,dwm desktop))

use/x11/leechcraft: use/x11
	@$(call add,THE_PACKAGES,leechcraft)

use/x11/kde: use/x11/xorg +pipewire
ifeq (,$(filter-out sisyphus p11,$(BRANCH)))
	@$(call add,THE_LISTS,kde/kde)
	@$(call add,THE_PACKAGES,kde-volume-control-7-pipewire)
	@$(call add,PINNED_PACKAGES,kde-volume-control-7-pipewire)
else
	@$(call add,THE_LISTS,kde/kde5)
	@$(call add,THE_PACKAGES,kde5-volume-control-4-pipewire)
	@$(call add,PINNED_PACKAGES,kde5-volume-control-4-pipewire)
endif

## screensavers
use/x11/xscreensaver:
	@$(call add,THE_LISTS,$(call tags,base xscreensaver))

use/x11/xscreensaver/gl: use/x11/xscreensaver
	@$(call add,THE_LISTS,$(call tags,desktop xscreensaver))

use/x11/xscreensaver/frontend: use/x11/xscreensaver
	@$(call add,THE_PACKAGES,xscreensaver-frontend)
