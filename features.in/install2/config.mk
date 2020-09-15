# alterator-based installer, second (livecd) stage

+installer: use/install2/full; @:

use/install2: use/stage2 sub/stage2@install2 use/metadata \
	use/cleanup/installer use/install2/autoinstall use/grub/install2.cfg
	@$(call add_feature)
	@$(call try,INSTALLER,altlinux-generic)	# might be replaced later
	@$(call add,INSTALL2_PACKAGES,installer-distro-$$(INSTALLER)-stage2)
	@$(call add,INSTALL2_PACKAGES,branding-$$(BRANDING)-alterator)
	@$(call add,BASE_PACKAGES,branding-$$(BRANDING)-release)
	@$(call add,BASE_PACKAGES,installer-distro-$$(INSTALLER)-stage3)
	@$(call add,BASE_PACKAGES,installer-common-stage3)
	@$(call add,BASE_PACKAGES,glibc-gconv-modules)	# for guile22
	@$(call add,BASE_LISTS,$(call tags,basesystem && !alterator))
	@$(call xport,BASE_BOOTLOADER)
	@$(call xport,INSTALL2_CLEANUP_PACKAGES)
	@$(call xport,INSTALL2_CLEANUP_KDRIVERS)

# doesn't use/install2/fs on purpose (at least so far)
use/install2/full: \
	use/install2/packages use/install2/vmguest use/install2/tools \
	use/syslinux/localboot.cfg use/syslinux/ui/menu use/bootloader
	@$(call add,INSTALL2_PACKAGES,xorg-drv-synaptics)
	@$(call add,INSTALL2_PACKAGES,xorg-drv-libinput)

# for distributions with their own -stage3 installer part
use/install2/stage3: use/install2
	@$(call add,BASE_PACKAGES,installer-$$(INSTALLER)-stage3)

# just an alias, better use its endpoint directly
use/install2/fonts: use/fonts/install2; @:

# see also use/vmguest
ifeq (,$(filter-out i586 x86_64 aarch64 armh ppc64le,$(ARCH)))

# see also use/vmguest/kvm; qxl included in xorg pkglist
use/install2/kvm:
	@$(call add,INSTALL2_PACKAGES,spice-vdagent xorg-drv-qxl)

ifeq (,$(filter-out i586 x86_64,$(ARCH)))

# virtualbox guest support for installer
use/install2/vbox:
	@$(call add,STAGE1_KMODULES,virtualbox-addition vboxguest)
	@$(call add,INSTALL2_PACKAGES,xorg-drv-vboxvideo)

# see also use/vmguest/vmware
use/install2/vmware:
	@$(call add,STAGE1_KMODULES,vmware)
	@$(call add,STAGE1_KMODULES,scsi)	# mptspi in led-ws
	@$(call add,INSTALL2_PACKAGES,xorg-drv-vmware xorg-drv-vmmouse)

use/install2/vmguest: use/install2/kvm use/install2/vbox use/install2/vmware; @:

else

use/install2/vmguest: use/install2/kvm; @:

endif
else

use/install2/vmguest: ; @:

endif

# stash local packages within installation media
use/install2/packages: use/install2 use/repo/main; @:

# set up remote repositories within installed system out-of-box
use/install2/repo: use/install2
	@$(call add,INSTALL2_PACKAGES,installer-feature-online-repo)

# for alterator-pkg to use
use/install2/net: use/install2
	@$(call add,INSTALL2_PACKAGES,curl)

# for autoinstall
use/install2/autoinstall:
	@$(call add,INSTALL2_PACKAGES,alterator-postinstall)
	@$(call add,BASE_PACKAGES,alterator-postinstall)

# NB: sort of conflicts with use/install2/cleanup/vnc
use/install2/vnc:
	@$(call add,INSTALL2_PACKAGES,x11vnc xterm net-tools)

# this one expects external vncviewer to come
use/install2/vnc/listen: use/install2/vnc \
	use/syslinux/install-vnc-listen.cfg use/grub/install-vnc-listen.cfg; @:

# this one connects to a specified vncviewer --listen
use/install2/vnc/connect: use/install2/vnc \
	use/syslinux/install-vnc-connect.cfg use/grub/install-vnc-connect.cfg; @:

# add both bootloader items to be *that* explicit ;-)
use/install2/vnc/full: use/install2/vnc/listen use/install2/vnc/connect; @:

# filesystems handling
use/install2/fs: use/install2/xfs use/install2/jfs use/install2/reiserfs; @:

use/install2/xfs:
	@$(call add,SYSTEM_PACKAGES,xfsprogs)

use/install2/jfs:
	@$(call add,SYSTEM_PACKAGES,jfsutils)

use/install2/reiserfs:
	@$(call add,SYSTEM_PACKAGES,reiserfsprogs)

use/install2/fat:
	@$(call add,SYSTEM_PACKAGES,dosfstools fatresize)

# prepare bootloader for software suspend (see also live)
use/install2/suspend:
	@$(call add,INSTALL2_PACKAGES,installer-feature-desktop-suspend-stage2)

# extras
use/install2/tools:
	@$(call add,INSTALL2_PACKAGES,pxz)
	@$(call add,INSTALL2_PACKAGES,fdisk gdisk parted partclone)
	@$(call add,INSTALL2_PACKAGES,vim-console)
	@$(call add,INSTALL2_PACKAGES,net-tools openssh-clients lftp)

# when VNC installation is less welcome than a few extra megs
use/install2/cleanup/vnc:
	@$(call add,INSTALL2_CLEANUP_PACKAGES,x11vnc xorg-xvfb)

# when VNC installation is less welcome than a few extra megs
use/install2/cleanup/dri:
	@$(call set,INSTALL2_CLEANUP_DRI,yes)
	@$(call xport,INSTALL2_CLEANUP_DRI)

# conflicts with luks feature
use/install2/cleanup/crypto:
	@$(call add,INSTALL2_CLEANUP_PACKAGES,gnupg)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,libgnutls*)

# leave only cirrus, fbdev, qxl, vesa in vm-targeted images
use/install2/cleanup/x11-hwdrivers:
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-drv-ati xorg-drv-intel)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-glamor)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-drv-mach64 xorg-drv-mga)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-drv-nouveau)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-drv-openchrome)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-drv-r128 xorg-drv-radeon)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-drv-s3virge xorg-drv-savage)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,xorg-drv-sis)

# massive purge of anything not critical to installer boot (l10n included!)
use/install2/cleanup/everything: use/install2/cleanup/x11-hwdrivers \
	use/install2/cleanup/vnc use/install2/cleanup/crypto
	@$(call add,INSTALL2_CLEANUP_PACKAGES,glibc-locales)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,libX11-locales alterator-l10n)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,kbd-data kbd console-scripts)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,shadow-convert)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,libXaw xmessage xconsole)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,libncurses libncursesw) # top
	@$(call add,INSTALL2_CLEANUP_PACKAGES,openssl) # net-functions
	@$(call add,INSTALL2_CLEANUP_PACKAGES,vitmp vim-minimal)
	@$(call add,INSTALL2_CLEANUP_PACKAGES,udev-hwdb pciids)

# this conflicts with efi (which needs efivars.ko)
use/install2/cleanup/kernel/firmware:
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/firmware/)

# drop drivers expected to be useless in virtual environment
use/install2/cleanup/kernel/non-vm:
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/firewire/)
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/net/bonding/)
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/net/ppp/)
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/net/slip/)
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/net/team/)
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/net/usb/)
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/platform/)
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/tty/serial/)
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/net/bridge/)
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/net/openvswitch/)

# this would need extra handling anyways
use/install2/cleanup/kernel/storage:
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/block/aoe/)
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/block/drbd/)

# burn it down
use/install2/cleanup/kernel/everything: \
	use/install2/cleanup/kernel/storage \
	use/install2/cleanup/kernel/non-vm \
	use/install2/cleanup/kernel/firmware
	@$(call add,INSTALL2_CLEANUP_KDRIVERS,kernel/drivers/ata/pata_*)
