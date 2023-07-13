# set up initrd-bootchain config

ifneq (,$(BUILDDIR))

include $(BUILDDIR)/distcfg.mk

BOOTCHAIN_CFG := $(BUILDDIR)/stage1/files/.disk/bootchain

all: debug
	@[ -s "$(BOOTCHAIN_CFG)" ] || exit 1; \
	if [ -n "$(META_VOL_ID)" ]; then \
		DISTRO="$(META_VOL_ID)"; \
	else \
		DISTRO="$(RELNAME)"; \
	fi; \
	sed -i -e "s,@distro@,$$DISTRO," \
		-e "s,@bc_fgvt_activate@,$(BOOTCHAIN_BC_FGVT_ACTIVATE)," \
		-e "s,@waitdev_timeout@,$(BOOTCHAIN_WAITDEV_TIMEOUT)," \
		-e "s,@oem_welcome_text@,$(BOOTCHAIN_OEM_WELCOME_TEXT)," \
		-e "s,@oem_cdroot@,$(BOOTCHAIN_OEM_CDROOT)," \
		-e "s,@oem_default_stage2@,$(BOOTCHAIN_OEM_DEFAULT_STAGE2)," \
		-e "s,@oem_live_storage@,$(BOOTCHAIN_OEM_LIVE_STORAGE)," \
		-e "s,@oem_bad_storage@,$(BOOTCHAIN_OEM_BAD_STORAGE)," \
		-e "s,@oem_setup_storage@,$(BOOTCHAIN_OEM_SETUP_STORAGE)," \
		-e "s,@oem_images_base@,$(BOOTCHAIN_OEM_IMAGES_BASE)," \
		-e "s,@oem_overlays_dir@,$(BOOTCHAIN_OEM_OVERLAYS_DIR)," \
		-e "s,@oem_url_netinst@,$(BOOTCHAIN_OEM_URL_NETINST)," \
		-e "s,@oem_srv_netinst@,$(BOOTCHAIN_OEM_SRV_NETINST)," \
		-e "s,@oem_nfs_netinst@,$(BOOTCHAIN_OEM_NFS_NETINST)," \
		-e "s,@oem_cifs_netinst@,$(BOOTCHAIN_OEM_CIFS_NETINST)," \
		-e "s,@bc_logfile@,$(BOOTCHAIN_LOGFILE)," \
		-e "s,@bc_log_vt@,$(BOOTCHAIN_LOG_VT)," \
		$(BOOTCHAIN_CFG)

debug:
	@if [ -n "$(DEBUG)" ]; then \
		echo "** DISTRO: $(DISTRO)"; \
	fi

endif
