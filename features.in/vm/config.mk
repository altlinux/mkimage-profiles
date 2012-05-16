+vmguest: use/vm/virtualbox/guest use/vm/kvm/guest; @:

use/vm/virtualbox/guest:
	@$(call add_feature)
	@$(call add,THE_KMODULES,virtualbox-addition drm)
	@$(call add,THE_PACKAGES,virtualbox-guest-additions)

# NB: only reasonable for X11-bearing images
use/vm/kvm/guest:
	@$(call add_feature)
	@$(call add,THE_PACKAGES,spice-vdagent)

# see also use/install2/kvm
