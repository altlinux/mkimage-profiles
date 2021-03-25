# "1" is not a typo
use/stage2: sub/stage1 use/uuid-iso
	@$(call add_feature)
	@$(call add,STAGE1_PACKAGES,make-initrd file iproute2)
	@$(call add,STAGE1_PACKAGES,make-initrd-propagator propagator)
	@$(call add,STAGE1_MODLISTS,$$(FEATURES))
	@$(call xport,STAGE1_PACKAGES)
	@$(call xport,STAGE1_KCONFIG)

# building blocks for propagator's module cove
use/stage2/ata use/stage2/drm use/stage2/fs use/stage2/hid use/stage2/md \
	use/stage2/mmc use/stage2/net use/stage2/net-cifs use/stage2/net-nfs \
	use/stage2/pcmcia use/stage2/rtc use/stage2/scsi use/stage2/usb \
	use/stage2/virtio: \
	use/stage2/%: use/stage2
	@$(call add,STAGE1_MODLISTS,stage2-$*)

use/stage2/sbc: use/stage2
ifeq (,$(filter-out aarch64,$(ARCH)))
	@$(call add,STAGE1_MODLISTS,stage2-sbc-aarch64)
endif
	@:

use/stage2/kms: use/stage2/drm use/drm/stage2/full; @:

use/stage2/kms/nvidia: use/stage2/kms \
	use/drm/stage2/nvidia; @:

# install mount.cifs to stage1
# NB: there's builtin nfsmount there, no reason for nfs-utils
use/stage2/cifs: use/stage2/net-cifs
	@$(call add,STAGE1_PACKAGES,cifs-utils)

# eth0 instead of enp0s3
use/stage2/net-eth: use/stage2
	@$(call add,STAGE1_PACKAGES,udev-rule-generator-net)
	@$(call add,STAGE2_PACKAGES,udev-rule-generator-net livecd-net-eth)

# NB: sub/stage2 isn't used standalone but rather
#     as a base for various livecd modifications
#     (currently install2, live, rescue)
