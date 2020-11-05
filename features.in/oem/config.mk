use/oem: use/services use/branding
	@$(call add_feature)
	@$(call add,DEFAULT_SERVICES_ENABLE,messagebus alteratord)
	@$(call add,THE_PACKAGES,alterator-setup alterator-notes)
	@$(call add,THE_PACKAGES,rootfs-installer-features)
	@$(call add,THE_BRANDING,alterator notes)
	@$(call try,OEM_TARGET,setup)
	@$(call add,DEFAULT_SERVICES_ENABLE,$$(OEM_TARGET))
	@$(call xport,OEM_TARGET)
	@$(call xport,OEM_NO_CLEANUP)
	@$(call xport,OEM_STEPS)

use/oem/vnc: use/oem use/x11-vnc use/net-eth/dhcp
	@$(call add,THE_PACKAGES,alterator-setup-x11vnc)
	@$(call set,OEM_TARGET,setup-vnc)
	@$(call set,NMCTL,no)
	@$(call xport,NMCTL)

use/oem/no-cleanup: use/oem
	@$(call set,OEM_NO_CLEANUP,yes)
