### this might really belong to build-*...

# distributions
DISTRO_EXTS := .iso

use/pack::
	@$(call add_feature)

ifeq (,$(filter-out e2k%,$(ARCH)))
use/pack:: use/e2k; @:
endif

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

ifeq (ve,$(IMAGE_CLASS))
$(foreach c,$(VE_ARCHIVES), \
	$(eval $(call PACK_containers,$(c))) \
	$(foreach z,$(VE_COMPRESSORS), \
		$(eval $(call PACK_compressors,$(c),$(z)))))
endif

# extensions for buld-vm
VM_EXTS := .tar .tar.gz .tar.xz .img .qcow2 .qcow2c .vdi .vmdk .vhd
VM_TAVOLGA_EXTS := .recovery.tar

ifeq (vm,$(IMAGE_CLASS))

$(VM_EXTS:.%=use/pack/%): use/pack; @:

ifeq (mipsel,$(ARCH))
use/pack/recovery.tar: use/pack/tar; @:
endif

endif
