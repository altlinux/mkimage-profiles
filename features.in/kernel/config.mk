# choose std kernel flavour for max RAM size support
ifeq (i586,$(ARCH))
BIGRAM := std-pae
else
BIGRAM := std-def
endif

use/kernel:
	@$(call add_feature)
ifeq (,$(filter-out e2k%,$(ARCH)))
	@$(call try,KFLAVOURS,elbrus-def)
else
ifeq (,$(filter-out aarch64 armh,$(ARCH)))
	@$(call try,KFLAVOURS,mp)
else
ifeq (,$(filter-out riscv64,$(ARCH)))
	@$(call try,KFLAVOURS,un-def)
else
	@$(call try,KFLAVOURS,std-def)
endif
endif
endif

# r8168 is a kludge, never install it by default
use/kernel/net:
	@$(call add,THE_KMODULES,e1000e igb)
	@$(call add,MAIN_KMODULES,r8168 rtl8168)

use/kernel/wireless: use/firmware/wireless
	@$(call add,THE_KMODULES,bcmwl ndiswrapper)

use/kernel/laptop: use/firmware/laptop
	@$(call add,THE_KMODULES,omnibook tp_smapi)

use/kernel/desktop:
	@$(call add,THE_KMODULES,lirc v4l)

use/kernel/server:
	@$(call add,THE_KMODULES,ipset kvm)

# for vm targets
use/kernel/initrd-setup: use/kernel
	@$(call add,VM_INITRDFEATURES,add-modules compress cleanup)
	@$(call try,VM_FSTYPE,ext4)
	@$(call add,VM_INITRDMODULES,$$(VM_FSTYPE))
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call add,VM_INITRDFEATURES,qemu)
	@$(call add,VM_INITRDMODULES,ata_piix)
endif
ifeq (,$(filter-out e2k%,$(ARCH)))
	@$(call add,VM_INITRDFEATURES,usb)
endif
ifeq (,$(filter-out ppc64le,$(ARCH)))
	@$(call add,VM_INITRDFEATURES,qemu usb)
	@$(call add,VM_INITRDMODULES,ipr ibmvscsi)
endif
ifeq (,$(filter-out i586 x86_64 aarch64 armh ppc64le,$(ARCH)))
	@$(call add,VM_INITRDMODULES,ahci sd_mod)
	@$(call add,VM_INITRDMODULES,nvme nvme-core)
	@$(call add,VM_INITRDMODULES,virtio-scsi virtio-blk virtio-rng)
endif
ifeq (,$(filter-out aarch64 armh,$(ARCH)))
	@$(call add,VM_INITRDMODULES,bcm2835 sunxi-mmc)
	@$(call add,VM_INITRDMODULES,nvmem_rockchip_efuse)
	@$(call add,VM_INITRDMODULES,virtio-mmio)
endif
ifeq (,$(filter-out aarch64,$(ARCH)))
	@$(call add,VM_INITRDMODULES,meson-gx-mmc)
	@$(call add,VM_INITRDMODULES,nvmem_meson_efuse)
endif
ifeq (,$(filter-out armh,$(ARCH)))
	@$(call add,VM_INITRDMODULES,sdhci_dove sdhci_esdhc_imx)
endif
	@$(call xport,VM_INITRDMODULES)
	@$(call xport,VM_INITRDFEATURES)
