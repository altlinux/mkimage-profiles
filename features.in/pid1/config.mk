# choose the smallest suitable kernel
use/pid1: sub/stage1 use/syslinux/timeout/1
	@$(call add_feature)
	@$(call add,STAGE1_PACKAGES,make-initrd)
	@$(call add,STAGE2_BOOTARGS,quiet)
	@$(call add,STAGE2_BOOTARGS,panic=$$(PID1_PANIC))
	@$(call add,STAGE2_BOOTARGS,rdinit=$$(PID1_BIN))
	@$(call add,SYSLINUX_CFG,pid1)
	@$(call try,PID1_PANIC,3)
	@$(call xport,PID1_PANIC)
	@$(call xport,PID1_BIN)
ifeq (i586,$(ARCH))
	@$(call set,KFLAVOURS,ltsp-client)
endif

# need a kernel with CONFIG_IP_PNP_DHCP
# NB: make-initrd must support resolver setup!
use/pid1/net: use/pid1
	@$(call add,STAGE2_BOOTARGS,ip=dhcp)
	@$(call add,STAGE1_PACKAGES,chrooted-resolv)
