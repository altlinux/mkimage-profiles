# alterator-based installer, second (livecd) stage

+installer: use/install2/full; @:

use/install2: use/stage2 sub/stage2@install2 use/metadata \
	use/cleanup/installer use/bootloader
	@$(call add_feature)
	@$(call try,INSTALLER,altlinux-generic)	# might be replaced later
	@$(call add,INSTALL2_PACKAGES,installer-distro-$$(INSTALLER)-stage2)
	@$(call add,INSTALL2_PACKAGES,branding-$$(BRANDING)-alterator)
	@$(call add,BASE_PACKAGES,branding-$$(BRANDING)-release)
	@$(call add,BASE_PACKAGES,installer-common-stage3)
	@$(call add,BASE_LISTS,$(call tags,basesystem))
	@$(call xport,BASE_BOOTLOADER)
	@$(call xport,INSTALL2_CLEANUP_PACKAGES)

# doesn't use/install2/fs on purpose (at least so far)
use/install2/full: use/install2/packages use/install2/kms \
	use/install2/kvm use/install2/vbox \
	use/syslinux/localboot.cfg use/syslinux/ui/menu; @:

# stash local packages within installation media
use/install2/packages: use/install2 use/repo/main; @:

# for alterator-pkg to use
use/install2/net: use/install2
	@$(call add,INSTALL2_PACKAGES,curl)

# modern free xorg drivers for mainstream hardware require KMS support
use/install2/kms: use/stage2/kms
	@$(call add,BASE_KMODULES_REGEXP,drm.*)

# see also use/vmguest/kvm; qxl included in xorg pkglist
use/install2/kvm:
	@$(call add,INSTALL2_PACKAGES,spice-vdagent xorg-drv-qxl)

# virtualbox guest support for installer
use/install2/vbox:
	@$(call add,STAGE1_KMODULES,virtualbox-addition vboxguest)

# filesystems handling
use/install2/fs: use/install2/xfs use/install2/jfs use/install2/reiserfs; @:

use/install2/xfs:
	@$(call add,SYSTEM_PACKAGES,xfsprogs)

use/install2/jfs:
	@$(call add,SYSTEM_PACKAGES,jfsutils)

use/install2/reiserfs:
	@$(call add,SYSTEM_PACKAGES,reiserfsprogs)

# when VNC installation is less welcome than a few extra megs
use/install2/cleanup/vnc:
	@$(call add,INSTALL2_CLEANUP_PACKAGES,x11vnc xorg-xvfb)

# conflicts with luks feature
use/install2/cleanup/crypto:
	@$(call add,INSTALL2_CLEANUP_PACKAGES,gnupg libgpg-error)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,libgcrypt* libgnutls*)

# leave only cirrus, fbdev, qxl, vesa in vm-targeted images
use/install2/cleanup/x11-hwdrivers:
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-drv-ati xorg-drv-intel)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-glamor)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-drv-mach64 xorg-drv-mga)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-drv-nouveau xorg-drv-nv)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-drv-openchrome)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-drv-r128 xorg-drv-radeon)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-drv-s3virge xorg-drv-savage)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-drv-sis)
