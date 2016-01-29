# NB: if the firmware is needed in installer,
#     it should be installed to stage1's *instrumental* chroot
#     for mkmodpack to use

use/firmware:
	@$(call add_feature)
	@$(call add,SYSTEM_PACKAGES,firmware-linux)

use/firmware/full: use/firmware/server use/firmware/laptop; @:

use/firmware/cpu: use/firmware
	@$(call add,THE_PACKAGES,microcode-data-intel microcode_ctl)

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
# FIXME: kernel modules rather belong to use/hardware
use/firmware/wireless: use/firmware use/kernel/wireless
	@$(call add,THE_PACKAGES,firmware-acx100)
	@$(call add,THE_PACKAGES_REGEXP,firmware-prism.*)
	@$(call add,THE_PACKAGES_REGEXP,firmware-ipw.*)
	@$(call add,THE_PACKAGES_REGEXP,firmware-zd.*)

use/firmware/laptop: use/firmware/wireless use/firmware/cpu
	@$(call add,KMODULES,acpi_call)
