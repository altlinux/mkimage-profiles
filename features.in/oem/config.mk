use/oem: use/services use/branding use/deflogin/root
	@$(call add_feature)
	@$(call add,DEFAULT_SERVICES_ENABLE,messagebus alteratord)
	@$(call add,BASE_PACKAGES,alterator-setup alterator-notes)
	@$(call add,BASE_PACKAGES,rootfs-installer-features)
	@$(call add,BASE_BRANDING,alterator notes)
	@$(call try,OEM_TARGET,setup)
	@$(call add,DEFAULT_SERVICES_ENABLE,$$(OEM_TARGET))
	@$(call xport,OEM_TARGET)
	@$(call xport,OEM_NO_CLEANUP)
	@$(call xport,OEM_STEPS)
	@$(call xport,OEM_INSTALL)

use/oem/vnc: use/oem
	@$(call add,BASE_PACKAGES,alterator-vnc)
	@$(call add,BASE_PACKAGES,x11vnc x11vnc-service xorg-drv-dummy)

use/oem/no-cleanup: use/oem
	@$(call set,OEM_NO_CLEANUP,yes)

use/oem/distro: use/oem
	@$(call try,OEM_STEPS,sysconfig notes-license datetime \
		preinstall net-eth root users setup-finish)
	@$(call add,BASE_PACKAGES,alterator-net-eth)
	@$(call add,BASE_PACKAGES,installer-common-stage3)

use/oem/install: use/oem use/repo/main
	@$(call set,OEM_INSTALL,yes)
	@$(call try,OEM_STEPS,sysconfig notes-license datetime pkg \
		preinstall net-eth root users setup-finish)
	@$(call add,BASE_PACKAGES,alterator-pkg alterator-net-eth)
	@$(call add,BASE_PACKAGES,installer-common-stage3)
