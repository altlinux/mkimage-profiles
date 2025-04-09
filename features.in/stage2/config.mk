# "1" is not a typo
use/stage2:: sub/stage1
	@$(call add_feature)
	@$(call add,STAGE1_PACKAGES,make-initrd file iproute2)
	@$(call add,STAGE1_MODLISTS,$$(FEATURES))
ifeq (,$(filter-out sisyphus p11 c11%,$(BRANCH)))
	@$(call try,INSTALL2_INIT,init=/usr/libexec/install2/install2-init)
else
	@$(call try,INSTALL2_INIT,init=/usr/sbin/install2-init)
endif
	@$(call xport,STAGE1_PACKAGES)
	@$(call xport,STAGE1_KCONFIG)

ifeq (,$(filter-out sisyphus p11 c11%,$(BRANCH)))
use/stage2:: use/initrd-bootchain; @:
else
use/stage2:: use/initrd-propagator; @:
endif

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

# initrd without nouveau; see ALT bug 31971
use/stage2/kms/nvidia: use/stage2/drm use/drm/stage2/nvidia; @:

# install mount.cifs to stage1
# NB: there's builtin nfsmount there, no reason for nfs-utils
use/stage2/cifs: use/stage2/net-cifs
	@$(call add,STAGE1_PACKAGES,cifs-utils)

# grub submenu 'Network installation'
use/stage2/net-install: use/stage2/net use/stage2/cifs \
	use/stage2/net-nfs use/grub/netinstall.cfg; @:

# grub submenu 'Network installation' with stagename live only
use/stage2/net-install-live: use/stage2/net use/stage2/cifs \
	use/stage2/net-nfs use/grub/netinstall-live.cfg; @:

# eth0 instead of enp0s3
use/stage2/net-eth: use/stage2

# NB: sub/stage2 isn't used standalone but rather
#     as a base for various livecd modifications
#     (currently install2, live, rescue)
