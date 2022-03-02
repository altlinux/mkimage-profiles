# various VM guest modules/tools
+vmguest: use/vmguest/complete; @:

use/vmguest:
	@$(call add_feature)

use/vmguest/bare: use/vmguest/vbox use/vmguest/kvm; @:
use/vmguest/base: use/vmguest/bare use/vmguest/vmware; @:
use/vmguest/complete: use/vmguest/base \
	use/vmguest/vbox/x11 use/vmguest/vmware/x11 use/vmguest/kvm/x11; @:

ifeq (,$(filter-out i586 x86_64 aarch64 armh ppc64le riscv64,$(ARCH)))
# NB: only reasonable for X11-bearing images
# see also use/install2/kvm
use/vmguest/kvm: use/vmguest; @:
ifneq (riscv64,$(ARCH))
	@$(call add,THE_PACKAGES,qemu-guest-agent)
endif

use/vmguest/kvm/x11: use/vmguest/kvm
	@$(call add,THE_PACKAGES,spice-vdagent xorg-drv-qxl xorg-drv-spiceqxl)
ifneq (p9,$(BRANCH))
ifneq (,$(filter-out armh,$(ARCH)))
	@$(call add,THE_PACKAGES,xorg-dri-virtio)
endif
endif
else
use/vmguest/kvm use/vmguest/kvm/x11: ; @:
endif

ifeq (,$(filter-out i586 x86_64,$(ARCH)))
use/vmguest/vbox: use/vmguest; @:

use/vmguest/vbox/x11: use/vmguest/vbox
	@$(call add,THE_KMODULES,drm)
	@$(call add,THE_PACKAGES,virtualbox-guest-additions)

# see also use/install2/vmware
use/vmguest/vmware:
	@$(call add,THE_KMODULES,vmware)
	@$(call add,THE_KMODULES,scsi)	# mptspi.ko
	@$(call add,THE_PACKAGES,open-vm-tools)

use/vmguest/vmware/x11: use/vmguest/vmware
	@$(call add,THE_PACKAGES,xorg-dri-vmwgfx xorg-drv-vmware xorg-drv-vmmouse)
	@$(call add,THE_PACKAGES,open-vm-tools-desktop)
else
use/vmguest/vbox use/vmguest/vbox/x11 \
use/vmguest/vmware use/vmguest/vmware/x11: ; @:
endif
