DISTRO_EXTS := .iso
VE_EXTS     := .tar .tgz

use/pack:
	@$(call add_feature)

use/pack/iso: use/pack boot/isolinux
ifeq (distro,$(IMAGE_CLASS))
	@$(call set,IMAGE_PACKTYPE,isoboot)
else
	@$(call set,IMAGE_PACKTYPE,isodata)
endif

use/pack/tar: use/pack
	@$(call set,IMAGE_PACKTYPE,tar)

use/pack/tgz: use/pack/tar
	@$(call set,IMAGE_COMPRESS,gzip)
