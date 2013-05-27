+live: use/live/desktop; @:

# copy stage2 as live
# NB: starts to preconfigure but doesn't use/cleanup yet
use/live: use/stage2 sub/rootfs@live sub/stage2@live
	@$(call add_feature)
	@$(call add,CLEANUP_PACKAGES,'installer*')

use/live/base: use/live use/syslinux/ui/menu
	@$(call add,LIVE_LISTS,$(call tags,base && (live || network)))

# rw slice, see http://www.altlinux.org/make-initrd-propagator and #28289
ifeq (,$(EFI_BOOTLOADER))
use/live/rw: use/live use/syslinux
	@$(call add,SYSLINUX_CFG,live_rw)
else
use/live/rw: use/live; @:
endif

# graphical target (not enforcing xorg drivers or blobs)
use/live/x11: use/live/base use/x11-autologin use/live/sound +power +efi
	@$(call add,LIVE_LISTS,$(call tags,desktop && (live || network)))
	@$(call add,LIVE_LISTS,$(call tags,base l10n))
	@$(call add,LIVE_PACKAGES,fonts-ttf-dejavu fonts-ttf-droid)
	@$(call add,LIVE_PACKAGES,pciutils)
	@$(call add,SYSLINUX_CFG,localboot)

# this target specifically pulls free xorg drivers in (and a few more bits)
use/live/desktop: use/live/x11 use/x11/xorg use/x11/wacom +vmguest; @:

# preconfigure apt for both live and installed-from-live systems
use/live/repo: use/live
	@$(call add,LIVE_PACKAGES,installer-feature-online-repo)
	@$(call try,LIVE_REPO,http/alt)
	@$(call xport,LIVE_REPO)

# preconfigure apt in runtime (less reliable)
use/live/repo/online:
	@$(call add,LIVE_PACKAGES,livecd-online-repo)

# alterator-based permanent installation
use/live/install: use/metadata use/syslinux/localboot.cfg
	@$(call add,LIVE_PACKAGES,livecd-install)
	@$(call add,LIVE_PACKAGES,livecd-installer-features)

# text-based installation script
use/live/textinstall: use/syslinux/localboot.cfg
	@$(call add,LIVE_PACKAGES,live-install)

# a very simplistic one
use/live/.x11: use/live use/x11 use/x11-autologin
	@$(call add,LIVE_PACKAGES,xinit)

# NB: some implementation has to be added if it's not a display manager
use/live/autologin: use/live/.x11
	@$(call add,LIVE_PACKAGES,autologin)

use/live/nodm: use/live/.x11
	@$(call add,LIVE_PACKAGES,nodm)

# see also http://www.altlinux.org/Netbook-live/hooks
use/live/hooks: use/live
	@$(call add,LIVE_PACKAGES,livecd-run-hooks)

# a crude hack to make sure Russian is supported in a particular image
use/live/ru: use/live
	@$(call add,LIVE_PACKAGES,livecd-ru)

use/live/sound: use/live
	@$(call add,LIVE_PACKAGES,amixer alsa-utils aplay udev-alsa)
