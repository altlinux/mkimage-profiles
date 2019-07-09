# various VM guest modules/tools
ifeq (,$(filter-out i586 x86_64 aarch64 armh ppc64le,$(ARCH)))

use/vmguest:
	@$(call add_feature)

# NB: only reasonable for X11-bearing images
# see also use/install2/kvm
use/vmguest/kvm: use/vmguest
	@$(call add,THE_PACKAGES,qemu-guest-agent)

use/vmguest/kvm/x11: use/vmguest/kvm
	@$(call add,THE_PACKAGES,spice-vdagent xorg-drv-qxl)

ifeq (,$(filter-out i586 x86_64,$(ARCH)))

use/vmguest/bare: use/vmguest/vbox use/vmguest/kvm; @:
use/vmguest/base: use/vmguest/bare use/vmguest/vmware; @:
use/vmguest/complete: use/vmguest/base \
	use/vmguest/vbox/x11 use/vmguest/vmware/x11 use/vmguest/kvm/x11; @:

use/vmguest/vbox: use/vmguest
	@$(call add,THE_KMODULES,virtualbox-addition vboxguest)

use/vmguest/vbox/x11: use/vmguest/vbox
	@$(call add,THE_KMODULES,drm)
	@$(call add,THE_PACKAGES,virtualbox-guest-additions)

# see also use/install2/vmware
use/vmguest/vmware:
	@$(call add,THE_KMODULES,vmware)
	@$(call add,THE_KMODULES,scsi)	# mptspi.ko
	@$(call add,THE_PACKAGES,open-vm-tools)

use/vmguest/vmware/x11: use/vmguest/vmware
	@$(call add,THE_PACKAGES,xorg-drv-vmware xorg-drv-vmmouse open-vm-tools-desktop)

else

# non-x86
use/vmguest/bare: use/vmguest/kvm; @:
use/vmguest/base: use/vmguest/bare; @:
use/vmguest/complete: use/vmguest/base use/vmguest/kvm/x11; @:

endif

else

# kvm-unsupported guest arch
use/vmguest/bare: ; @:
use/vmguest/base: ; @:
use/vmguest/complete: ; @:

endif

+vmguest: use/vmguest/complete; @:
