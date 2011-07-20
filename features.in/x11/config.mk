use/x11/xorg:
	@$(call add,BASE_LISTS,xorg)

### strictly speaking, runlevel5 should require a *dm, not vice versa
use/x11/runlevel5: use/x11/xorg
	@$(call add,BASE_PACKAGES,installer-feature-runlevel5-stage3)

### xdm: see also #23108
use/x11/xdm: use/x11/runlevel5
	@$(call add,BASE_PACKAGES,xdm installer-feature-no-xconsole)
