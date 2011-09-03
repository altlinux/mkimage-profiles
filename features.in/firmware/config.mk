# NB: if the firmware is needed in installer,
#     it should be installed to stage1's *instrumental* chroot
#     for mkmodpack to use

use/firmware:
	@$(call add,SYSTEM_PACKAGES,firmware-linux)

use/firmware/server: use/firmware
	@$(call add,SYSTEM_PACKAGES,firmware-aic94xx-seq)
	@$(call add,MAIN_PACKAGES_REGEXP,firmware-ql.*)

use/firmware/desktop: use/firmware
	@$(call add,SYSTEM_PACKAGES,firmware-psb)

use/firmware/wireless: use/firmware
	@$(call add,MAIN_PACKAGES,firmware-acx100)
	@$(call add,MAIN_PACKAGES,firmware-i2400m)
	@$(call add,MAIN_PACKAGES_REGEXP,firmware-ipw.*)
	@$(call add,MAIN_PACKAGES_REGEXP,firmware-iwl.*)
	@$(call add,MAIN_PACKAGES_REGEXP,firmware-rt.*)
	@$(call add,MAIN_PACKAGES_REGEXP,firmware-zd.*)
