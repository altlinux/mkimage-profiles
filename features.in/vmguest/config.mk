+vmguest: use/vmguest/complete; @:

use/vmguest:
	@$(call add_feature)

use/vmguest/base: use/vmguest/vbox use/vmguest/vmware; @:
use/vmguest/complete: use/vmguest/base use/vmguest/vbox/x11 use/vmguest/kvm; @:

use/vmguest/vbox: use/vmguest
	@$(call add,THE_KMODULES,virtualbox-addition vboxguest)

use/vmguest/vbox/x11: use/vmguest/vbox
	@$(call add,THE_KMODULES,drm)
	@$(call add,THE_PACKAGES,virtualbox-guest-additions)

# NB: only reasonable for X11-bearing images
# see also use/install2/kvm
use/vmguest/kvm: use/vmguest
	@$(call add,THE_PACKAGES,spice-vdagent qemu-guest-agent)

# see also use/install2/vmware
use/vmguest/vmware:
	@$(call add,THE_KMODULES,vmware)
	@$(call add,THE_KMODULES,scsi)	# mptspi.ko

use/vmguest/vmware/x11: use/vmguest/vmware
	@$(call add,THE_PACKAGES,xorg-drv-vmware)
