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
	@$(call add,THE_KMODULES,e1000e)
	@$(call add,THE_KMODULES,r8125)
	@$(call add,MAIN_KMODULES,r8168 rtl8168)

use/kernel/wireless: use/firmware/wireless
	@$(call add,THE_KMODULES,bcmwl staging)
	@$(call add,THE_KMODULES,rtl8188fu rtl8192eu rtl8723de rtl8812au)
	@$(call add,THE_KMODULES,rtl8821ce rtl8821cu rtl88x2bu rtl8723bu)

use/kernel/laptop: use/firmware/laptop; @:

use/kernel/desktop:
	@$(call add,THE_KMODULES,v4l)

use/kernel/drm: use/drm; @:

use/kernel/server:
	@$(call add,THE_KMODULES,ipset kvm)

# for vm targets
use/kernel/initrd-setup: use/kernel
	@$(call try,VM_FSTYPE,ext4)
	@$(call add,VM_INITRDMODULES,$$(VM_FSTYPE))
	@$(call add,VM_INITRDMODULES,ahci sd_mod)
	@$(call add,VM_INITRDMODULES,nvme nvme-core)
	@$(call add,VM_INITRDMODULES,ahci_platform ehci-pci ohci-pci uhci-hcd xhci-pci uas)
	@$(call add,VM_INITRDMODULES,sdhci-acpi sdhci-pci sdhci-pltfm xhci-plat-hcd dwc2 mmc_block)
	@$(call add,VM_INITRDMODULES,usbhid)
	@$(call add,VM_INITRDMODULES,evdev)
ifeq (,$(filter-out i586 x86_64,$(ARCH)))
	@$(call add,VM_INITRDMODULES,ata_piix)
endif
ifeq (,$(filter-out i586 x86_64 aarch64 armh e2k% ppc64le mipsel,$(ARCH)))
	@$(call add,VM_INITRDFEATURES,usb)
endif
ifneq (,$(filter-out e2k% riscv64 mipsel,$(ARCH)))
	@$(call add,VM_INITRDFEATURES,qemu)
endif
	@$(call add,VM_INITRDMODULES,virtio-scsi virtio-blk virtio-rng virtio_net virtio-gpu)
	@$(call add,VM_INITRDMODULES,virtio-mmio virtio_pci virtio_console virtio_input)
ifeq (,$(filter-out ppc64le,$(ARCH)))
	@$(call add,VM_INITRDMODULES,ipr ibmvscsi)
endif
ifeq (,$(filter-out aarch64 armh,$(ARCH)))
	@$(call add,VM_INITRDMODULES,bcm2835 bcm2835-dma sunxi-mmc)
	@$(call add,VM_INITRDMODULES,reset_raspberrypi)
	@$(call add,VM_INITRDMODULES,nvmem_rockchip_efuse)
	@$(call add,VM_INITRDMODULES,pwm-meson)
	@$(call add,VM_INITRDMODULES,cb710-mmc mtk-sd tifm_sd usdhi6rol0 via-sdmmc)
	@$(call add,VM_INITRDMODULES,mmc_spi of_mmc_spi toshsd ushc vub300)
	@$(call add,VM_INITRDMODULES,smssdio sdio_uart armmmci.ko dw_mmc-pltfm dw_mmc-pci)
	@$(call add,VM_INITRDMODULES,tifm_sd sdhci-msm toshsd ushc)
	@$(call add,VM_INITRDMODULES,cqhci mmc_spi via-sdmmc dw_mmc-exynos)
	@$(call add,VM_INITRDMODULES,vub300 dw_mmc-k3)
	@$(call add,VM_INITRDMODULES,sdhci-tegra sdhci-cadence sunxi-mmc dw_mmc-pci)
	@$(call add,VM_INITRDMODULES,sdhci-iproc thunderx-mmc meson-gx-mmc)
	@$(call add,VM_INITRDMODULES,nvme-fabrics nvme-rdma)
	@$(call add,VM_INITRDMODULES,pci-stub aer_inject)
	@$(call add,VM_INITRDMODULES,phy-sun4i-usb phy-sun6i-mipi-dphy phy-sun9i-usb)
	@$(call add,VM_INITRDMODULES,phy-hi6220-usb phy-hisi-inno-usb2)
	@$(call add,VM_INITRDMODULES,phy-rockchip-dp phy-rockchip-inno-usb2 phy-rockchip-usb)
	@$(call add,VM_INITRDMODULES,phy-rockchip-emmc)
	@$(call add,VM_INITRDMODULES,phy-rockchip-typec)
	@$(call add,VM_INITRDMODULES,phy-exynos5-usbdrd phy-tegra-xusb phy-xgene)
	@$(call add,VM_INITRDMODULES,meson-canvas mdt_loader)
	@$(call add,VM_INITRDMODULES,usb_phy_generic)
endif
ifeq (,$(filter-out aarch64,$(ARCH)))
	@$(call add,VM_INITRDMODULES,meson-gx-mmc)
	@$(call add,VM_INITRDMODULES,nvmem_meson_efuse)
	@$(call add,VM_INITRDMODULES,pcie-rockchip-host phy-rockchip-pcie)
	@$(call add,VM_INITRDMODULES,rk808 i2c-rk3x sdhci-of-arasan sdhci)
	@$(call add,VM_INITRDMODULES,dw_mmc dw_mmc-rockchip phy-rockchip-emmc)
	@$(call add,VM_INITRDMODULES,pinctrl-rk805 rockchip-io-domain)
	@$(call add,VM_INITRDMODULES,pwm-rockchip rk808-regulator)
endif
ifeq (,$(filter-out armh,$(ARCH)))
	@$(call add,VM_INITRDMODULES,sdhci_dove sdhci_esdhc_imx)
endif
	@$(call xport,VM_INITRDMODULES)
	@$(call xport,VM_INITRDFEATURES)
	@$(call xport,VM_FSTYPE)
