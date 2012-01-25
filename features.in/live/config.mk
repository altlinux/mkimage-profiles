# copy stage2 as live
use/live: use/stage2 sub/stage2/live
	@$(call add_feature)

use/live/base: use/live use/syslinux/ui-menu
	@$(call add,LIVE_LISTS,$(call tags,base && (live || network)))

use/live/x11: use/live/base use/x11/xorg use/x11/wacom use/virtualbox/guest

# NB: there's an unconditional live/image-scripts.d/40-autologin script
#     *but* it only configures some of the *existing* means; let's add one
use/live/autologin: use/live/x11
	@$(call add,LIVE_PACKAGES,autologin xinit)

use/live/hooks: use/live
	@$(call add,LIVE_PACKAGES,livecd-run-hooks)
