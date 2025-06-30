# NB: if the firmware is needed in installer,
#     it should be installed to stage1's *instrumental* chroot
#     for mkmodpack to use

use/firmware:
	@$(call add_feature)
	@$(call add,SYSTEM_PACKAGES,firmware-linux)
ifeq (,$(filter-out aarch64,$(ARCH)))
	@$(call add,THE_PACKAGES,firmware-bcm4345)
	@$(call add,THE_PACKAGES,firmware-linux-qcom)
endif
ifeq (,$(filter-out x86_64,$(ARCH)))
	@$(call add,THE_PACKAGES,firmware-alsa-sof)
endif

use/firmware/full: use/firmware/server use/firmware/laptop; @:

ifeq (,$(filter-out i586 x86_64,$(ARCH)))
use/firmware/cpu: use/firmware
	@$(call add,THE_PACKAGES,firmware-intel-ucode iucode_tool)
	@$(call add,BASE_PACKAGES,make-initrd-ucode)
else
use/firmware/cpu: use/firmware; @:
endif

use/firmware/server: use/firmware
	@$(call add,SYSTEM_PACKAGES,firmware-aic94xx-seq)
ifneq (,$(filter-out riscv64,$(ARCH)))
	@$(call add,SYSTEM_PACKAGES,firmware-ast_dp501)
endif
	@$(call add,THE_PACKAGES_REGEXP,firmware-ql.*)
	@$(call add,SYSTEM_PACKAGES,firmware-linux-mellanox)
	@$(call add,MAIN_PACKAGES,firmware-linux-mrvl)
	@$(call add,MAIN_PACKAGES,firmware-linux-qcom)

use/firmware/qlogic: use/firmware
	@$(call add,SYSTEM_PACKAGES,firmware-ql6312)

# NB: individual firmwarez would sometimes conflict
#     with ones newly merged into firmware-linux
use/firmware/wireless: use/firmware
	@$(call add,THE_PACKAGES_REGEXP,firmware-prism.*)
	@$(call add,THE_PACKAGES_REGEXP,firmware-ipw.*)
	@$(call add,THE_PACKAGES_REGEXP,firmware-zd.*)

use/firmware/laptop: use/firmware/cpu; @:
