# NB: if the firmware is needed in installer,
#     it should be installed to stage1's *instrumental* chroot
#     for mkmodpack to use

use/firmware:
	@$(call add_feature)
	@$(call add,SYSTEM_PACKAGES,firmware-linux)

use/firmware/cpu: use/firmware
	@$(call add,THE_PACKAGES,firmware-amd-ucode)
	@$(call add,THE_PACKAGES,microcode-data-intel microcode_ctl)

use/firmware/server: use/firmware
	@$(call add,SYSTEM_PACKAGES,firmware-aic94xx-seq)
	@$(call add,THE_PACKAGES_REGEXP,firmware-ql.*)

# NB: individual firmwarez would sometimes conflict
#     with ones newly merged into firmware-linux
# FIXME: kernel modules rather belong to use/hardware
use/firmware/wireless: use/firmware
	@$(call add,THE_KMODULES,bcmwl ndiswrapper)
	@$(call add,THE_PACKAGES,firmware-acx100)
	@#$(call add,THE_PACKAGES,firmware-i2400m)
	@$(call add,THE_PACKAGES_REGEXP,firmware-carl9170.*)
	@$(call add,THE_PACKAGES_REGEXP,firmware-prism.*)
	@$(call add,THE_PACKAGES_REGEXP,firmware-ipw.*)
	@#$(call add,THE_PACKAGES_REGEXP,firmware-iwl.*)
	@#$(call add,THE_PACKAGES_REGEXP,firmware-rt.*)
	@$(call add,THE_PACKAGES_REGEXP,firmware-zd.*)

use/firmware/laptop: use/firmware/wireless use/firmware/cpu
	@$(call add,KMODULES,acpi_call)
