+live: use/live/desktop; @:

# copy stage2 as live
# NB: starts to preconfigure but doesn't use/cleanup yet
use/live: use/stage2 sub/stage2/live
	@$(call add_feature)
	@$(call add,CLEANUP_PACKAGES,'installer*')

use/live/base: use/live use/syslinux/ui/menu
	@$(call add,LIVE_LISTS,$(call tags,base && (live || network)))

# optimized out: use/x11/xorg
use/live/desktop: use/live/base use/x11/wacom use/virtualbox/guest +power
	@$(call add,LIVE_LISTS,$(call tags,desktop && (live || network)))
	@$(call add,LIVE_PACKAGES,fonts-ttf-dejavu fonts-ttf-droid)
	@$(call add,SYSLINUX_CFG,localboot)

# NB: there's an unconditional live/image-scripts.d/40-autologin script
#     *but* it only configures some of the *existing* means; let's add one
#     for the cases when there should be no display manager
use/live/autologin: use/live use/x11/xorg
	@$(call add,LIVE_PACKAGES,autologin xinit)

use/live/hooks: use/live
	@$(call add,LIVE_PACKAGES,livecd-run-hooks)

use/live/ru: use/live
	@$(call add,LIVE_PACKAGES,livecd-ru)
