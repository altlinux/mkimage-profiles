# NB: if the firmware is needed in installer,
#     it should be installed to stage1's *instrumental* chroot
#     for mkmodpack to use

use/firmware:
	@$(call add_feature)
	@$(call add,SYSTEM_PACKAGES,firmware-linux)

use/firmware/full: use/firmware/server use/firmware/laptop; @:

use/firmware/cpu: use/firmware
	@$(call add,THE_PACKAGES,firmware-intel-ucode iucode_tool)

use/firmware/server: use/firmware
	@$(call add,SYSTEM_PACKAGES,firmware-aic94xx-seq)
	@$(call add,THE_PACKAGES_REGEXP,firmware-ql.*)

use/firmware/qlogic: use/firmware
	@$(call add,SYSTEM_PACKAGES,firmware-ql2100)
	@$(call add,SYSTEM_PACKAGES,firmware-ql2200)
	@$(call add,SYSTEM_PACKAGES,firmware-ql2300)
	@$(call add,SYSTEM_PACKAGES,firmware-ql2322)
	@$(call add,SYSTEM_PACKAGES,firmware-ql2400)
	@$(call add,SYSTEM_PACKAGES,firmware-ql2500)
	@$(call add,SYSTEM_PACKAGES,firmware-ql6312)

# NB: individual firmwarez would sometimes conflict
#     with ones newly merged into firmware-linux
use/firmware/wireless: use/firmware
	@$(call add,THE_PACKAGES,firmware-acx100)
	@$(call add,THE_PACKAGES_REGEXP,firmware-prism.*)
	@$(call add,THE_PACKAGES_REGEXP,firmware-ipw.*)
	@$(call add,THE_PACKAGES_REGEXP,firmware-zd.*)
	@$(call add,THE_PACKAGES_REGEXP,firmware-rt.*)

use/firmware/laptop: use/firmware/cpu
	@$(call add,KMODULES,acpi_call)
