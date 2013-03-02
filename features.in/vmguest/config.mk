+vmguest: use/vmguest/virtualbox use/vmguest/kvm; @:

use/vmguest:
	@$(call add_feature)

use/vmguest/virtualbox: use/vmguest
	@$(call add,THE_KMODULES,virtualbox-addition drm)
	@$(call add,THE_PACKAGES,virtualbox-guest-additions)

# NB: only reasonable for X11-bearing images
use/vmguest/kvm: use/vmguest
	@$(call add,THE_PACKAGES,spice-vdagent)

# see also use/install2/kvm
