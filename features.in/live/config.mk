use/live: use/stage2 sub/stage2/live
	@$(call add_feature)

use/live/base: use/live use/syslinux/ui-menu
	@$(call add,LIVE_LISTS,$(call tags,base && (live || network)))

# NB: there's an unconditional live/image-scripts.d/40-autologin script
#     *but* it only configures some of the *existing* means; let's add one
use/live/autologin: use/live/base
	@$(call add,LIVE_PACKAGES,autologin xinit)

use/live/icewm: use/live/autologin
	@$(call add,LIVE_LISTS, \
		$(call tags,(base || desktop) && (live || network || icewm)))

# this is a manual installation script (text-based)
use/live/install: use/live/base
	@$(call add,LIVE_PACKAGES,live-install)
