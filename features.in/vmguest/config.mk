+vmguest: use/vmguest/complete; @:

use/vmguest:
	@$(call add_feature)

use/vmguest/base: use/vmguest/vbox/base use/vmguest/vmware; @:
use/vmguest/complete: use/vmguest/base use/vmguest/vbox use/vmguest/kvm; @:

use/vmguest/vbox/base: use/vmguest
	@$(call add,THE_KMODULES,virtualbox-addition vboxguest drm)

use/vmguest/vbox: use/vmguest/vbox/base
	@$(call add,THE_PACKAGES,virtualbox-guest-additions)

# NB: only reasonable for X11-bearing images
# see also use/install2/kvm
use/vmguest/kvm: use/vmguest
	@$(call add,THE_PACKAGES,spice-vdagent)

# see also use/install2/vmware
use/vmguest/vmware:
	@$(call add,THE_KMODULES,vmware)
	@$(call add,THE_KMODULES,scsi)	# mptspi.ko
