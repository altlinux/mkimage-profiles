use/kernel:
	@$(call add_feature)
ifeq (,$(filter-out e2k%,$(ARCH)))
	@$(call try,KFLAVOURS,elbrus-def)
else
ifeq (,$(filter-out riscv64,$(ARCH)))
	@$(call try,KFLAVOURS,un-def)
else
	@$(call try,KFLAVOURS,std-def)
endif
endif
	@$(call xport,KFLAVOURS)

use/kernel/latest: use/kernel; @:
ifeq (,$(filter-out aarch64 armh i586 ppc64le x86_64,$(ARCH)))
	@$(call set,KFLAVOURS,un-def)
endif

# r8168 is a kludge, never install it by default
use/kernel/net:
	@$(call add,THE_KMODULES,r8125)
	@$(call add,MAIN_KMODULES,r8168 rtl8168)

use/kernel/wireless: use/firmware/wireless
	@$(call add,THE_KMODULES,staging)
	@$(call add,THE_KMODULES,rtl8188fu rtl8192eu rtl8723de rtl8812au)
	@$(call add,THE_KMODULES,rtl8821ce rtl8821cu rtl88x2bu rtl8723bu)
	@$(call add,THE_KMODULES,rtw89)

use/kernel/laptop: use/firmware/laptop; @:

use/kernel/desktop:
	@$(call add,THE_KMODULES,v4l)

use/kernel/drm: use/drm; @:

use/kernel/server:
	@$(call add,THE_KMODULES,ipset kvm)

use/kernel/disable-usb-autosuspend:
	@$(call add,BASE_BOOTARGS,usbcore.autosuspend=-1)
	@$(call add,STAGE2_BOOTARGS,usbcore.autosuspend=-1)
	@$(call add,SYSTEM_PACKAGES,disable-usb-autosuspend)

# for vm targets
use/kernel/initrd-setup: use/kernel
	@$(call try,VM_FSTYPE,ext4)
	@$(call add,VM_INITRDMODULES,$$(VM_FSTYPE))
	@$(call add,VM_INITRDMODULES,ahci.ko ahci_platform.ko sd_mod.ko)
	@$(call add,VM_INITRDMODULES,usbhid.ko usbkbd.ko)
	@$(call add,VM_INITRDMODULES,evdev.ko)
	@$(call add,VM_INITRDMODULES,drivers/pci)
	@$(call add,VM_INITRDMODULES,drivers/mmc drivers/usb/host)
	@$(call add,VM_INITRDMODULES,drivers/usb/storage drivers/nvmem drivers/nvme)
	@$(call add,VM_INITRDMODULES,drivers/virtio)
	@$(call add,VM_INITRDMODULES,drm/virtio)
	@$(call add,VM_INITRDMODULES,virtio_scsi.ko virtio_blk.ko virtio-rng virtio_net.ko virtio-gpu.ko)
	@$(call add,VM_INITRDMODULES,virtio-mmio.ko virtio_pci.ko virtio_console.ko virtio_input.ko)
	@$(call add,VM_INITRDMODULES,drivers/video/fbdev)
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call add,VM_INITRDMODULES,ata_piix.ko)
endif
ifeq (,$(filter-out i586 x86_64 aarch64 armh e2k% ppc64le mipsel,$(ARCH)))
	@$(call add,VM_INITRDFEATURES,usb)
endif
ifneq (,$(filter-out e2k% riscv64 mipsel,$(ARCH)))
	@$(call add,VM_INITRDFEATURES,qemu)
endif
ifeq (,$(filter-out ppc64le,$(ARCH)))
	@$(call add,VM_INITRDMODULES,ipr.ko ibmvscsi.ko)
endif
ifeq (,$(filter-out aarch64 armh riscv64,$(ARCH)))
	@$(call add,VM_INITRDMODULES,drivers/dma drivers/reset)
	@$(call add,VM_INITRDMODULES,drivers/usb/dwc2 drivers/usb/dwc3)
	@$(call add,VM_INITRDMODULES,drivers/phy drivers/usb/phy)
	@$(call add,VM_INITRDMODULES,drivers/bus)
	@$(call add,VM_INITRDMODULES,drivers/soc)
	@$(call add,VM_INITRDMODULES,drivers/pwm drivers/regulator)
	@$(call add,VM_INITRDMODULES,drivers/i2c)
	@$(call add,VM_INITRDMODULES,drivers/mfd)
	@$(call add,VM_INITRDMODULES,drivers/spi)
	@$(call add,VM_INITRDMODULES,drivers/clk)
	@$(call add,VM_INITRDMODULES,drivers/gpu/drm/bridge)
	@$(call add,VM_INITRDMODULES,drivers/gpu/drm/rockchip)
	@$(call add,VM_INITRDMODULES,drivers/gpu/drm/sun4i)
	@$(call add,VM_INITRDMODULES,tegra-drm.ko)
endif
	@$(call xport,VM_INITRDMODULES)
	@$(call xport,VM_INITRDFEATURES)
	@$(call xport,VM_FSTYPE)
