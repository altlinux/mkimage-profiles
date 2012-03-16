+live: use/live/desktop

# copy stage2 as live
use/live: use/stage2 sub/stage2/live
	@$(call add_feature)

use/live/base: use/live use/syslinux/ui-menu
	@$(call add,LIVE_LISTS,$(call tags,base && (live || network)))

use/live/desktop: use/live/base use/x11/xorg use/x11/wacom \
	use/firmware use/virtualbox/guest \
	use/power/acpi/button use/power/acpi/cpufreq
	@$(call add,LIVE_LISTS,$(call tags,desktop && (live || network)))

# NB: there's an unconditional live/image-scripts.d/40-autologin script
#     *but* it only configures some of the *existing* means; let's add one
#     for the cases when there should be no display manager
use/live/autologin: use/live/desktop
	@$(call add,LIVE_PACKAGES,autologin xinit)

use/live/hooks: use/live
	@$(call add,LIVE_PACKAGES,livecd-run-hooks)
