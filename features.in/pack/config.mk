### this might really belong to build-*...

# distributions
DISTRO_EXTS := .iso

use/pack:
	@$(call add_feature)

# fallback type is isodata, might get set elsewhere to produce bootable iso
use/pack/iso: use/pack
	@$(call try,IMAGE_PACKTYPE,isodata)

# virtual environments
VE_ARCHIVES := tar cpio ubifs
VE_COMPRESSORS := gz xz# there's no sense in bzip2 by now
VE_ZIPS := $(call addsuffices, \
		$(addprefix .,$(VE_COMPRESSORS)), \
			$(VE_ARCHIVES))# tar.gz cpio.xz ...
VE_EXTS := $(sort $(addprefix .,$(VE_ARCHIVES) $(VE_ZIPS)))# .tar .tar.gz ...

# generate rules for archive/compressor combinations
define PACK_containers
use/pack/$(1): use/pack
	@$$(call set,IMAGE_PACKTYPE,$(1))
endef

define PACK_compressors
use/pack/$(1).$(2): use/pack/$(1)
	@$$(call set,IMAGE_COMPRESS,$(2))
endef

$(foreach c,$(VE_ARCHIVES), \
	$(eval $(call PACK_containers,$(c))) \
	$(foreach z,$(VE_COMPRESSORS), \
		$(eval $(call PACK_compressors,$(c),$(z)))))

# virtual machines
VM_EXTS := .img .qcow2 .qcow2c .vdi .vmdk .vhd

$(VM_EXTS:.%=use/pack/%): use/pack; @:
