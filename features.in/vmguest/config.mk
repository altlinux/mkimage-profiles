# various VM guest modules/tools
+vmguest: use/vmguest/complete; @:

use/vmguest:
	@$(call add_feature)

use/vmguest/bare: use/vmguest/vbox use/vmguest/kvm; @:
use/vmguest/base: use/vmguest/bare use/vmguest/vmware; @:
use/vmguest/dri: use/vmguest/vbox/dri use/vmguest/vmware/dri \
	use/vmguest/kvm/dri; @:
use/vmguest/complete: use/vmguest/vbox/x11 use/vmguest/vmware/x11 \
	use/vmguest/kvm/x11; @:

ifeq (,$(filter-out i586 x86_64 aarch64 armh loongarch64 ppc64le riscv64,$(ARCH)))
# NB: only reasonable for X11-bearing images
# see also use/install2/kvm
use/vmguest/kvm: use/vmguest; @:
	@$(call add,THE_PACKAGES,qemu-guest-agent)

use/vmguest/kvm/dri: use/vmguest
	@$(call add,THE_PACKAGES,xorg-dri-virtio)

use/vmguest/kvm/x11: use/vmguest/kvm use/vmguest/kvm/dri
	@$(call add,THE_PACKAGES,spice-vdagent xorg-drv-qxl xorg-drv-spiceqxl)
else
use/vmguest/kvm: ; @:
use/vmguest/kvm/%: ; @:
endif

ifeq (,$(filter-out i586 x86_64,$(ARCH)))
use/vmguest/vbox: use/vmguest; @:

use/vmguest/vbox/dri: use/vmguest
	@$(call add,THE_KMODULES,drm)
	@$(call add,THE_PACKAGES,xorg-dri-vmwgfx)

use/vmguest/vbox/x11: use/vmguest/vbox use/vmguest/vbox/dri
	@$(call add,THE_PACKAGES,virtualbox-guest-additions)

# see also use/install2/vmware
use/vmguest/vmware: use/vmguest
	@$(call add,THE_PACKAGES,open-vm-tools)

use/vmguest/vmware/dri: use/vmguest
	@$(call add,THE_PACKAGES,xorg-dri-vmwgfx)

use/vmguest/vmware/x11: use/vmguest/vmware use/vmguest/vmware/dri
	@$(call add,THE_PACKAGES,xorg-drv-vmware xorg-drv-vmmouse)
	@$(call add,THE_PACKAGES,open-vm-tools-desktop)
else
use/vmguest/vbox use/vmguest/vmware: ; @:
use/vmguest/vbox/% use/vmguest/vmware/%: ; @:
endif
